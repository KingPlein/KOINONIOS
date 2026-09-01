import 'package:sqflite/sqflite.dart';
import '../../database/app_database.dart';
import '../../models/bible_models.dart';

/// Local data source for Bible verses using SQLite
class BibleLocalDataSource {
  final AppDatabase _db;

  BibleLocalDataSource({AppDatabase? db}) : _db = db ?? AppDatabase();

  /// Cache a verse locally
  Future<void> cacheVerse(BibleVerse verse) async {
    await _db.into(_db.verses).insertOnConflictUpdate(
      VersesCompanion(
        reference: Value(verse.reference),
        book: Value(verse.book),
        chapter: Value(verse.chapter),
        verseNumber: Value(verse.verseNumber),
        translation: Value(verse.translation),
        text: Value(verse.text),
        cachedAt: Value(DateTime.now()),
        testament: Value(verse.testament),
      ),
    );
  }

  /// Cache multiple verses (entire chapter)
  Future<void> cacheVerses(List<BibleVerse> verses) async {
    final batch = _db.batch();
    
    for (final verse in verses) {
      batch.insert(
        _db.verses,
        VersesCompanion(
          reference: Value(verse.reference),
          book: Value(verse.book),
          chapter: Value(verse.chapter),
          verseNumber: Value(verse.verseNumber),
          translation: Value(verse.translation),
          text: Value(verse.text),
          cachedAt: Value(DateTime.now()),
          testament: Value(verse.testament),
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  /// Get a cached verse by reference and translation
  Future<BibleVerse?> getCachedVerse(String reference, String translation) async {
    final results = await _db.getVerse(reference, translation);
    
    if (results == null) return null;
    
    return BibleVerse(
      reference: results.reference,
      book: results.book,
      chapter: results.chapter,
      verseNumber: results.verseNumber,
      text: results.text,
      translation: results.translation,
      testament: results.testament,
    );
  }

  /// Get all cached verses for a chapter
  Future<List<BibleVerse>> getCachedChapter(String book, int chapter, String translation) async {
    final results = await _db.getVersesByBook(book);
    
    return results
        .where((v) => v.chapter == chapter && v.translation == translation)
        .map((v) => BibleVerse(
              reference: v.reference,
              book: v.book,
              chapter: v.chapter,
              verseNumber: v.verseNumber,
              text: v.text,
              translation: v.translation,
              testament: v.testament,
            ))
        .toList();
  }

  /// Check if a chapter is fully cached
  Future<bool> isChapterCached(String book, int chapter, String translation) async {
    final cachedVerses = await getCachedChapter(book, chapter, translation);
    // A typical chapter has at least 1 verse
    return cachedVerses.isNotEmpty;
  }

  /// Search cached verses by text
  Future<List<BibleVerse>> searchCachedVerses(String query) async {
    final results = await _db.searchVerses(query);
    
    return results
        .map((v) => BibleVerse(
              reference: v.reference,
              book: v.book,
              chapter: v.chapter,
              verseNumber: v.verseNumber,
              text: v.text,
              translation: v.translation,
              testament: v.testament,
            ))
        .toList();
  }

  /// Get all cached verses (for offline mode)
  Future<List<BibleVerse>> getAllCachedVerses() async {
    final results = await (_db.select(_db.verses)).get();
    
    return results
        .map((v) => BibleVerse(
              reference: v.reference,
              book: v.book,
              chapter: v.chapter,
              verseNumber: v.verseNumber,
              text: v.text,
              translation: v.translation,
              testament: v.testament,
            ))
        .toList();
  }

  /// Delete old cached verses (older than specified days)
  Future<int> deleteOldCache(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    
    return await (_db.delete(_db.verses)
          ..where('cached_at < ?', [cutoff.toIso8601String()]))
        .go();
  }

  /// Clear entire cache
  Future<void> clearCache() async {
    await (_db.delete(_db.verses)).go();
  }

  /// Get cache statistics
  Future<Map<String, int>> getCacheStats() async {
    final allVerses = await (_db.select(_db.verses)).get();
    
    final byTranslation = <String, int>{};
    final byBook = <String, int>{};
    
    for (final verse in allVerses) {
      byTranslation[verse.translation] = (byTranslation[verse.translation] ?? 0) + 1;
      byBook[verse.book] = (byBook[verse.book] ?? 0) + 1;
    }
    
    return {
      'total': allVerses.length,
      ...byTranslation.map((k, v) => MapEntry('translation_$k', v)),
      ...byBook.map((k, v) => MapEntry('book_$k', v)),
    };
  }
}
