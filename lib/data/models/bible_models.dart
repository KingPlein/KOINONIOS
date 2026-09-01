import 'dart:convert';

/// Bible verse model for API responses and local display
class BibleVerse {
  final String reference;
  final String book;
  final int chapter;
  final int verseNumber;
  final String text;
  final String translation;
  final String? testament;

  BibleVerse({
    required this.reference,
    required this.book,
    required this.chapter,
    required this.verseNumber,
    required this.text,
    required this.translation,
    this.testament,
  });

  factory BibleVerse.fromJson(Map<String, dynamic> json, String translation) {
    return BibleVerse(
      reference: json['reference'] ?? '',
      book: json['book'] ?? '',
      chapter: json['chapter'] ?? 0,
      verseNumber: json['verse'] ?? 0,
      text: json['text'] ?? '',
      translation: translation,
      testament: json['testament'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'book': book,
      'chapter': chapter,
      'verse': verseNumber,
      'text': text,
      'translation': translation,
      'testament': testament,
    };
  }

  /// Parse fuzzy reference like "jn 316" to structured format
  static BibleVerseReference parseReference(String input) {
    final normalized = input.toLowerCase().trim();
    
    // Book abbreviation mappings
    final bookMap = {
      'gen': 'Genesis', 'ge': 'Genesis', 'gn': 'Genesis',
      'ex': 'Exodus', 'exo': 'Exodus',
      'lev': 'Leviticus', 'le': 'Leviticus', 'lv': 'Leviticus',
      'num': 'Numbers', 'nu': 'Numbers', 'nm': 'Numbers', 'nb': 'Numbers',
      'deut': 'Deuteronomy', 'dt': 'Deuteronomy', 'de': 'Deuteronomy',
      'josh': 'Joshua', 'jo': 'Joshua',
      'judg': 'Judges', 'ju': 'Judges', 'jdg': 'Judges',
      'ruth': 'Ruth', 'ru': 'Ruth',
      '1sam': '1 Samuel', '1 sa': '1 Samuel', '1sm': '1 Samuel',
      '2sam': '2 Samuel', '2 sa': '2 Samuel', '2sm': '2 Samuel',
      '1ki': '1 Kings', '1 k': '1 Kings', '1k': '1 Kings',
      '2ki': '2 Kings', '2 k': '2 Kings', '2k': '2 Kings',
      '1ch': '1 Chronicles', '1 ch': '1 Chronicles', '1chr': '1 Chronicles',
      '2ch': '2 Chronicles', '2 ch': '2 Chronicles', '2chr': '2 Chronicles',
      'ezra': 'Ezra', 'ez': 'Ezra',
      'neh': 'Nehemiah', 'ne': 'Nehemiah',
      'esth': 'Esther', 'es': 'Esther',
      'job': 'Job', 'jb': 'Job',
      'ps': 'Psalms', 'psalm': 'Psalms', 'pss': 'Psalms',
      'prov': 'Proverbs', 'pr': 'Proverbs', 'pv': 'Proverbs',
      'eccl': 'Ecclesiastes', 'ec': 'Ecclesiastes', 'qoh': 'Ecclesiastes',
      'song': 'Song of Solomon', 'so': 'Song of Solomon', 'sst': 'Song of Solomon',
      'isa': 'Isaiah', 'is': 'Isaiah',
      'jer': 'Jeremiah', 'je': 'Jeremiah', 'jr': 'Jeremiah',
      'lam': 'Lamentations', 'la': 'Lamentations',
      'ezek': 'Ezekiel', 'eze': 'Ezekiel', 'ezk': 'Ezekiel',
      'dan': 'Daniel', 'da': 'Daniel', 'dn': 'Daniel',
      'hos': 'Hosea', 'ho': 'Hosea',
      'joel': 'Joel', 'jl': 'Joel',
      'amos': 'Amos', 'am': 'Amos',
      'obad': 'Obadiah', 'ob': 'Obadiah',
      'jonah': 'Jonah', 'jon': 'Jonah',
      'mic': 'Micah', 'mc': 'Micah',
      'nah': 'Nahum', 'na': 'Nahum',
      'hab': 'Habakkuk', 'hb': 'Habakkuk',
      'zep': 'Zephaniah', 'zp': 'Zephaniah',
      'hag': 'Haggai', 'hg': 'Haggai',
      'zech': 'Zechariah', 'zc': 'Zechariah',
      'mal': 'Malachi', 'ml': 'Malachi',
      'matt': 'Matthew', 'mt': 'Matthew', 'mat': 'Matthew',
      'mark': 'Mark', 'mk': 'Mark', 'mr': 'Mark',
      'luke': 'Luke', 'lk': 'Luke', 'luk': 'Luke',
      'john': 'John', 'jn': 'John', 'jhn': 'John',
      'acts': 'Acts', 'ac': 'Acts',
      'rom': 'Romans', 'ro': 'Romans', 'rm': 'Romans',
      '1cor': '1 Corinthians', '1 co': '1 Corinthians', '1c': '1 Corinthians',
      '2cor': '2 Corinthians', '2 co': '2 Corinthians', '2c': '2 Corinthians',
      'gal': 'Galatians', 'ga': 'Galatians',
      'eph': 'Ephesians', 'ep': 'Ephesians',
      'phil': 'Philippians', 'php': 'Philippians', 'pp': 'Philippians',
      'col': 'Colossians', 'co': 'Colossians',
      '1thess': '1 Thessalonians', '1 th': '1 Thessalonians', '1ts': '1 Thessalonians',
      '2thess': '2 Thessalonians', '2 th': '2 Thessalonians', '2ts': '2 Thessalonians',
      '1tim': '1 Timothy', '1 ti': '1 Timothy', '1tm': '1 Timothy',
      '2tim': '2 Timothy', '2 ti': '2 Timothy', '2tm': '2 Timothy',
      'titus': 'Titus', 'ti': 'Titus',
      'phlm': 'Philemon', 'pm': 'Philemon',
      'heb': 'Hebrews', 'he': 'Hebrews', 'hw': 'Hebrews',
      'james': 'James', 'jm': 'James',
      '1pet': '1 Peter', '1 pe': '1 Peter', '1p': '1 Peter',
      '2pet': '2 Peter', '2 pe': '2 Peter', '2p': '2 Peter',
      '1john': '1 John', '1 jn': '1 John', '1j': '1 John',
      '2john': '2 John', '2 jn': '2 John', '2j': '2 John',
      '3john': '3 John', '3 jn': '3 John', '3j': '3 John',
      'jude': 'Jude', 'jd': 'Jude',
      'rev': 'Revelation', 're': 'Revelation', 'rv': 'Revelation', 'the revelation': 'Revelation',
    };

    // Try to match book abbreviation
    String? bookName;
    for (final entry in bookMap.entries) {
      if (normalized.startsWith(entry.key)) {
        bookName = entry.value;
        break;
      }
    }

    if (bookName == null) {
      // Try full book names
      final fullBooks = bookMap.values.toSet();
      for (final book in fullBooks) {
        if (normalized.startsWith(book.toLowerCase())) {
          bookName = book;
          break;
        }
      }
    }

    if (bookName == null) {
      throw FormatException('Unknown book: $input');
    }

    // Extract chapter and verse numbers
    final remaining = normalized.substring(bookMap.entries.firstWhere((e) => e.value == bookName).key.length).trim();
    final numbers = RegExp(r'\d+').allMatches(remaining).map((m) => int.parse(m.group(0)!)).toList();

    if (numbers.isEmpty) {
      throw FormatException('No chapter/verse found: $input');
    }

    final chapter = numbers[0];
    final verseNumber = numbers.length > 1 ? numbers[1] : 1;

    return BibleVerseReference(
      book: bookName,
      chapter: chapter,
      verseNumber: verseNumber,
    );
  }
}

/// Parsed reference without full verse data
class BibleVerseReference {
  final String book;
  final int chapter;
  final int verseNumber;

  BibleVerseReference({
    required this.book,
    required this.chapter,
    required this.verseNumber,
  });

  String get canonicalReference => '$book $chapter:$verseNumber';
}

/// Chapter with multiple verses
class BibleChapter {
  final String book;
  final int chapterNumber;
  final List<BibleVerse> verses;
  final String translation;

  BibleChapter({
    required this.book,
    required this.chapterNumber,
    required this.verses,
    required this.translation,
  });

  factory BibleChapter.fromJson(Map<String, dynamic> json, String translation) {
    final verses = (json['verses'] as List?)?.map((v) => BibleVerse.fromJson(v, translation)).toList() ?? [];
    return BibleChapter(
      book: json['book'] ?? '',
      chapterNumber: json['chapter'] ?? 0,
      verses: verses,
      translation: translation,
    );
  }

  String get fullText => verses.map((v) => v.text).join(' ');
}

/// Bible API response wrapper
class BibleApiResponse {
  final String? reference;
  final String? book;
  final int? chapter;
  final List<BibleVerse> verses;
  final String translation;

  BibleApiResponse({
    this.reference,
    this.book,
    this.chapter,
    required this.verses,
    required this.translation,
  });

  factory BibleApiResponse.fromJson(Map<String, dynamic> json, String translation) {
    final verses = (json['verses'] as List?)?.map((v) => BibleVerse.fromJson(v, translation)).toList() ?? [];
    return BibleApiResponse(
      reference: json['reference'],
      book: json['book'],
      chapter: json['chapter'],
      verses: verses,
      translation: translation,
    );
  }
}

/// Translation info with license status
class BibleTranslation {
  final String code;
  final String name;
  final String description;
  final bool requiresApiKey;
  final String? licenseNotice;
  final bool isPublicDomain;

  BibleTranslation({
    required this.code,
    required this.name,
    required this.description,
    this.requiresApiKey = false,
    this.licenseNotice,
    this.isPublicDomain = true,
  });

  static final List<BibleTranslation> supportedTranslations = [
    BibleTranslation(
      code: 'KJV',
      name: 'King James Version',
      description: 'Classic English translation (1611)',
      isPublicDomain: true,
    ),
    BibleTranslation(
      code: 'WEB',
      name: 'World English Bible',
      description: 'Modern public domain translation',
      isPublicDomain: true,
    ),
    BibleTranslation(
      code: 'BSB',
      name: 'Berean Study Bible',
      description: 'Clear and accurate modern translation',
      isPublicDomain: true,
    ),
    BibleTranslation(
      code: 'ASV',
      name: 'American Standard Version',
      description: 'Conservative translation (1901)',
      isPublicDomain: true,
    ),
    BibleTranslation(
      code: 'ESV',
      name: 'English Standard Version',
      description: 'Word-for-word translation',
      requiresApiKey: true,
      licenseNotice: 'ESV Bible text copyright 2001 by Crossway. Used by permission. All rights reserved.',
      isPublicDomain: false,
    ),
  ];
}
