import 'package:flutter/foundation.dart';
import '../models/bible_models.dart';
import '../sources/remote/bible_api_service.dart';
import '../sources/local/bible_local_data_source.dart';

/// Bible repository implementing offline-first strategy
/// Fetches from remote API, caches locally, serves from cache when offline
class BibleRepository extends ChangeNotifier {
  final BibleApiService _apiService;
  final BibleLocalDataSource _localDataSource;

  String _currentTranslation = 'KJV';
  bool _isOnline = true;
  bool _isLoading = false;
  String? _error;

  BibleRepository({
    BibleApiService? apiService,
    BibleLocalDataSource? localDataSource,
  })  : _apiService = apiService ?? BibleApiService(),
        _localDataSource = localDataSource ?? BibleLocalDataSource();

  // Getters
  String get currentTranslation => _currentTranslation;
  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Set current translation
  void setTranslation(String translation) {
    if (_currentTranslation == translation) return;
    _currentTranslation = translation;
    notifyListeners();
  }

  /// Update online status
  void updateOnlineStatus(bool isOnline) {
    if (_isOnline == isOnline) return;
    _isOnline = isOnline;
    notifyListeners();
  }

  /// Get a verse with offline-first strategy
  Future<BibleVerse> getVerse(String reference) async {
    _setLoading(true);
    _clearError();

    try {
      // Try cache first
      final cachedVerse = await _localDataSource.getCachedVerse(reference, _currentTranslation);
      
      if (cachedVerse != null) {
        _setLoading(false);
        return cachedVerse;
      }

      // If not in cache, fetch from API
      if (!_isOnline) {
        throw BibleOfflineException('Verse not in cache and device is offline');
      }

      final verse = await _apiService.getVerse(reference, _currentTranslation);
      
      // Cache the verse
      await _localDataSource.cacheVerse(verse);
      
      _setLoading(false);
      return verse;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  /// Get a chapter with offline-first strategy
  Future<BibleChapter> getChapter(String book, int chapter) async {
    _setLoading(true);
    _clearError();

    try {
      // Check if chapter is cached
      final isCached = await _localDataSource.isChapterCached(book, chapter, _currentTranslation);
      
      if (isCached) {
        final cachedVerses = await _localDataSource.getCachedChapter(book, chapter, _currentTranslation);
        _setLoading(false);
        
        return BibleChapter(
          book: book,
          chapterNumber: chapter,
          verses: cachedVerses,
          translation: _currentTranslation,
        );
      }

      // If not in cache, fetch from API
      if (!_isOnline) {
        throw BibleOfflineException('Chapter not in cache and device is offline');
      }

      final bibleChapter = await _apiService.getChapter(book, chapter, _currentTranslation);
      
      // Cache all verses
      await _localDataSource.cacheVerses(bibleChapter.verses);
      
      _setLoading(false);
      return bibleChapter;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  /// Search verses in local cache only
  Future<List<BibleVerse>> searchVerses(String query) async {
    _setLoading(true);
    _clearError();

    try {
      final results = await _localDataSource.searchCachedVerses(query);
      _setLoading(false);
      return results;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  /// Pre-cache a chapter for offline reading
  Future<void> preCacheChapter(String book, int chapter) async {
    if (!_isOnline) {
      throw BibleOfflineException('Cannot cache while offline');
    }

    try {
      final bibleChapter = await _apiService.getChapter(book, chapter, _currentTranslation);
      await _localDataSource.cacheVerses(bibleChapter.verses);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Clear old cache to free space
  Future<void> clearOldCache({int daysOld = 30}) async {
    await _localDataSource.deleteOldCache(daysOld);
  }

  /// Clear entire cache
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }

  /// Get cache statistics
  Future<Map<String, int>> getCacheStats() async {
    return await _localDataSource.getCacheStats();
  }

  /// Get daily verse (algorithmic selection from curated list)
  Future<BibleVerse> getDailyVerse() async {
    // Curated list of encouraging verses
    final curatedVerses = [
      'John 3:16',
      'Jeremiah 29:11',
      'Psalm 23:1',
      'Philippians 4:13',
      'Romans 8:28',
      'Isaiah 41:10',
      'Psalm 46:1',
      'Matthew 11:28',
      '2 Corinthians 12:9',
      'Joshua 1:9',
      'Psalm 119:105',
      'Proverbs 3:5-6',
      '1 Peter 5:7',
      'Psalm 34:8',
      'John 14:27',
    ];

    // Select verse based on day of year (deterministic but cycles through)
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final verseIndex = dayOfYear % curatedVerses.length;
    final reference = curatedVerses[verseIndex];

    return await getVerse(reference);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Custom exception for offline errors
class BibleOfflineException implements Exception {
  final String message;

  BibleOfflineException(this.message);

  @override
  String toString() => 'BibleOfflineException: $message';
}
