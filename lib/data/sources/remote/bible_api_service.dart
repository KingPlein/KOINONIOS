import 'package:dio/dio.dart';
import '../models/bible_models.dart';

/// Bible API service for fetching scripture from remote sources
class BibleApiService {
  final Dio _dio;
  
  static const String bibleApiComBaseUrl = 'https://bible-api.com';
  static const String helloAoBaseUrl = 'https://bibles.helloao.org/api/v1';
  
  BibleApiService({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch verse(s) from bible-api.com (Primary API)
  /// Supports: KJV, WEB, ASV, BBE
  /// Rate limit: 15 requests per 30 seconds per IP
  Future<BibleApiResponse> getVersesFromBibleApiCom(
    String reference, {
    String translation = 'kjv',
  }) async {
    try {
      final response = await _dio.get(
        '$bibleApiComBaseUrl/$reference',
        queryParameters: {'translation': translation.toLowerCase()},
      );

      if (response.statusCode == 200) {
        return BibleApiResponse.fromJson(response.data, translation.toUpperCase());
      } else {
        throw BibleApiException(
          'Failed to fetch verse: ${response.statusCode}',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw BibleApiException(
        'Network error: ${e.message}',
        e.response?.statusCode ?? 500,
      );
    }
  }

  /// Fetch chapter from bibles.helloao.org (Secondary API)
  /// Supports: KJV, WEB, BSB
  /// No rate limits, MIT license
  Future<BibleChapter> getChapterFromHelloAo(
    String book,
    int chapter, {
    String translation = 'kjv',
  }) async {
    try {
      final response = await _dio.get(
        '$helloAoBaseUrl/$translation/books/$book/chapters/$chapter.json',
      );

      if (response.statusCode == 200) {
        return BibleChapter.fromJson(response.data, translation.toUpperCase());
      } else {
        throw BibleApiException(
          'Failed to fetch chapter: ${response.statusCode}',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw BibleApiException(
        'Network error: ${e.message}',
        e.response?.statusCode ?? 500,
      );
    }
  }

  /// Fetch single verse with automatic fallback between APIs
  Future<BibleVerse> getVerse(String reference, String translation) async {
    // Try primary API first
    try {
      final response = await getVersesFromBibleApiCom(reference, translation: translation);
      if (response.verses.isNotEmpty) {
        return response.verses.first;
      }
    } catch (_) {
      // Fall through to secondary API
    }

    // Parse reference for secondary API
    final parsed = BibleVerse.parseReference(reference);
    
    try {
      final chapter = await getChapterFromHelloAo(
        parsed.book,
        parsed.chapter,
        translation: translation,
      );
      
      final verse = chapter.verses.firstWhere(
        (v) => v.verseNumber == parsed.verseNumber,
        orElse: () => throw BibleApiException('Verse not found', 404),
      );
      
      return verse;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch entire chapter with automatic fallback
  Future<BibleChapter> getChapter(String book, int chapter, String translation) async {
    // Try secondary API first (better for full chapters)
    try {
      return await getChapterFromHelloAo(book, chapter, translation: translation);
    } catch (_) {
      // Try to fetch verse by verse from primary API
      final verses = <BibleVerse>[];
      
      // We need to know how many verses are in the chapter
      // This is a limitation - we'd need a verse count table
      // For now, try fetching verses 1-50 and filter out failures
      for (int v = 1; v <= 50; v++) {
        try {
          final verse = await getVerse('$book $chapter:$v', translation);
          verses.add(verse);
        } catch (_) {
          // Stop when we hit a verse that doesn't exist
          break;
        }
      }
      
      if (verses.isEmpty) {
        throw BibleApiException('Chapter not available', 404);
      }
      
      return BibleChapter(
        book: book,
        chapterNumber: chapter,
        verses: verses,
        translation: translation,
      );
    }
  }

  /// Search for verses containing text (local search only - API doesn't support search)
  /// This method should be implemented in the repository layer with local DB
  Future<List<BibleVerse>> searchVersesLocal(String query) {
    throw UnimplementedError('Search must be implemented locally');
  }
}

/// Custom exception for Bible API errors
class BibleApiException implements Exception {
  final String message;
  final int statusCode;

  BibleApiException(this.message, this.statusCode);

  @override
  String toString() => 'BibleApiException: $message (Status: $statusCode)';
}

/// Translation availability checker
class TranslationAvailability {
  static const Map<String, List<String>> apiSupport = {
    'bible-api.com': ['kjv', 'web', 'asv', 'bbe'],
    'helloao.org': ['kjv', 'web', 'bsb'],
  };

  static bool isTranslationAvailable(String translation, String api) {
    final supported = apiSupport[api];
    if (supported == null) return false;
    return supported.contains(translation.toLowerCase());
  }

  static List<String> getAvailableTranslations(String api) {
    return apiSupport[api] ?? [];
  }

  /// Get best API for a given translation
  static String? getBestApiForTranslation(String translation) {
    final t = translation.toLowerCase();
    
    if (['kjv', 'web', 'asv', 'bbe'].contains(t)) {
      return 'bible-api.com';
    }
    
    if (['kjv', 'web', 'bsb'].contains(t)) {
      return 'helloao.org';
    }
    
    return null;
  }
}
