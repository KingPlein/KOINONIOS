import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Verse entity representing a cached Bible verse
class Verses extends Table {
  @PrimaryKey()
  TextColumn get reference => text()(); // e.g., "John 3:16"

  TextColumn get book => text()(); // e.g., "John"
  IntColumn get chapter => integer()(); // e.g., 3
  IntColumn get verseNumber => integer()(); // e.g., 16

  TextColumn get translation => text()(); // e.g., "KJV", "ESV"
  TextColumn get text => text()(); // The actual verse text

  DateTimeColumn get cachedAt => dateTime()();

  // Optional fields for cross-references
  TextColumn? get testament => text().nullable()(); // "OT" or "NT"
}

/// Note entity for journal entries
class Notes extends Table {
  @PrimaryKey()
  TextColumn get id => text()(); // UUID

  TextColumn get title => text()();
  TextColumn get content => text()(); // Markdown string

  TextColumn get type => text()(); // general, sermon, verse_study, prayer_list

  // Linked verses (stored as JSON array)
  TextColumn get linkedVerses => text()(); // JSON array of references

  TextColumn? get linkedSermonId => text().nullable()(); // UUID of linked sermon

  TextColumn get tags => text()(); // JSON array of tag strings

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isPinned => boolean()();
  TextColumn? get colorLabel => text().nullable()(); // none, yellow, green, blue, purple, red

  // Attachments
  TextColumn? get imagePaths => text().nullable()(); // JSON array of file paths
  TextColumn? get audioPath => text().nullable()(); // Path to audio recording
}

/// Alarm entity for reminders and notifications
class Alarms extends Table {
  @PrimaryKey()
  TextColumn get id => text()(); // UUID

  TextColumn get type => text()(); // daily_verse, study_session, prayer_reminder, sermon_live, streak_warning

  IntColumn get hour => integer()();
  IntColumn get minute => integer()();

  TextColumn get repeatDays => text()(); // JSON array [0,1,2,3,4,5,6] for S M T W T F S

  TextColumn? get label => text().nullable()(); // Custom label
  TextColumn? get soundPath => text().nullable()(); // Custom sound file path

  BoolColumn get isActive => boolean()();
  BoolColumn get isEnabled => boolean()(); // User toggle

  DateTimeColumn? get lastTriggered => dateTime().nullable()();
  DateTimeColumn? get nextOccurrence => dateTime().nullable()();

  IntColumn get snoozeMinutes => integer().withDefault(const Constant(5))();
}

/// Sermon entity for sermon library
class Sermons extends Table {
  @PrimaryKey()
  TextColumn get id => text()(); // UUID

  TextColumn get title => text()();
  TextColumn get speaker => text()();
  TextColumn get church => text()();
  TextColumn get scripture => text()(); // e.g., "Psalm 23"

  IntColumn get durationSeconds => integer()();

  TextColumn get type => text()(); // youtube, audio, video
  TextColumn get sourceUrl => text()();
  TextColumn? get thumbnailUrl => text().nullable()();

  DateTimeColumn get datePreached => dateTime()();

  BoolColumn get isFavorite => boolean()();
  BoolColumn get isDownloaded => boolean()();
  TextColumn? get localPath => text().nullable()();

  IntColumn get progressSeconds => integer().withDefault(const Constant(0))();

  TextColumn? get notes => text().nullable()(); // JSON array of note IDs

  DateTimeColumn get addedAt => dateTime()();
}

/// Transcript entity for speech-to-text results
class Transcripts extends Table {
  @PrimaryKey()
  TextColumn get id => text()(); // UUID

  TextColumn get title => text()();
  TextColumn get rawText => text()(); // Raw transcription output
  TextColumn get editedText => text()(); // User-edited version

  TextColumn? get linkedSermonId => text().nullable()();
  TextColumn? get linkedNoteId => text().nullable()();

  TextColumn get language => text()(); // e.g., "en-US"
  TextColumn get mode => text()(); // on_device or cloud

  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get durationSeconds => integer()();

  BoolColumn get isSaved => boolean()();
}

/// Highlight entity for verse highlights
class Highlights extends Table {
  @PrimaryKey()
  TextColumn get id => text()(); // UUID

  TextColumn get verseReference => text()(); // e.g., "John 3:16"
  TextColumn get translation => text()(); // e.g., "KJV"

  TextColumn get color => text()(); // yellow, green, blue, purple, red, orange

  TextColumn? get note => text().nullable()(); // Optional note attached to highlight

  DateTimeColumn get createdAt => dateTime()();
}

/// Reading progress entity for tracking reading plans
class ReadingProgress extends Table {
  @PrimaryKey()
  TextColumn get id => text()(); // UUID

  TextColumn get planType => text()(); // canonical, chronological, thematic
  TextColumn? get planName => text().nullable()();

  IntColumn get currentDay => integer()();
  IntColumn get totalDays => integer()();

  TextColumn get currentReading => text()(); // e.g., "Genesis 1-3"
  TextColumn? get readingsCompleted => text().nullable()(); // JSON array of completed readings

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn? get completedAt => dateTime().nullable()();

  BoolColumn get isActive => boolean()();
}

/// Settings entity for app preferences
class Settings extends Table {
  @PrimaryKey()
  TextColumn get key => text()();

  TextColumn get value => text()(); // Stored as JSON or string

  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [
  Verses,
  Notes,
  Alarms,
  Sermons,
  Transcripts,
  Highlights,
  ReadingProgress,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed default settings
        await into(settings).insertOnConflictUpdate(SettingsCompanion(
          key: const Value('default_translation'),
          value: const Value('KJV'),
          updatedAt: Value(DateTime.now()),
        ));
        await into(settings).insertOnConflictUpdate(SettingsCompanion(
          key: const Value('font_size'),
          value: const Value('16.0'),
          updatedAt: Value(DateTime.now()),
        ));
        await into(settings).insertOnConflictUpdate(SettingsCompanion(
          key: const Value('theme_mode'),
          value: const Value('system'),
          updatedAt: Value(DateTime.now()),
        ));
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations
      },
    );
  }

  // Custom queries for verses
  Future<List<Verse>> getVersesByBook(String book) {
    return (select(verses)..where((v) => v.book.equals(book))).get();
  }

  Future<Verse?> getVerse(String reference, String translation) {
    return (select(verses)
          ..where((v) => v.reference.equals(reference) & v.translation.equals(translation)))
        .getSingleOrNull();
  }

  Future<List<Verse>> searchVerses(String query) {
    return (select(verses)..where((v) => v.text.like('%$query%'))).get();
  }

  // Custom queries for notes
  Future<List<Note>> getPinnedNotes() {
    return (select(notes)..where((n) => n.isPinned.equals(true))).get();
  }

  Future<List<Note>> getNotesByTag(String tag) {
    return (select(notes)..where((n) => n.tags.like('%$tag%'))).get();
  }

  // Custom queries for sermons
  Future<List<Sermon>> getFavoriteSermons() {
    return (select(sermons)..where((s) => s.isFavorite.equals(true))).get();
  }

  Future<List<Sermon>> getDownloadedSermons() {
    return (select(sermons)..where((s) => s.isDownloaded.equals(true))).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'syntrophe.db'));
    return NativeDatabase.createInBackground(file);
  });
}
