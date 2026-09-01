import 'package:uuid/uuid.dart';

/// Note model for journal entries
class Note {
  final String id;
  final String title;
  final String content; // Markdown string
  final String type; // general, sermon, verse_study, prayer_list
  final List<String> linkedVerses;
  final String? linkedSermonId;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final String? colorLabel; // none, yellow, green, blue, purple, red
  final List<String>? imagePaths;
  final String? audioPath;

  Note({
    String? id,
    required this.title,
    required this.content,
    required this.type,
    this.linkedVerses = const [],
    this.linkedSermonId,
    this.tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
    this.colorLabel,
    this.imagePaths,
    this.audioPath,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'linked_verses': linkedVerses,
      'linked_sermon_id': linkedSermonId,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_pinned': isPinned,
      'color_label': colorLabel,
      'image_paths': imagePaths,
      'audio_path': audioPath,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'general',
      linkedVerses: (json['linked_verses'] as List?)?.cast<String>() ?? [],
      linkedSermonId: json['linked_sermon_id'],
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isPinned: json['is_pinned'] ?? false,
      colorLabel: json['color_label'],
      imagePaths: (json['image_paths'] as List?)?.cast<String>(),
      audioPath: json['audio_path'],
    );
  }

  Note copyWith({
    String? title,
    String? content,
    String? type,
    List<String>? linkedVerses,
    String? linkedSermonId,
    List<String>? tags,
    bool? isPinned,
    String? colorLabel,
    List<String>? imagePaths,
    String? audioPath,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      linkedVerses: linkedVerses ?? this.linkedVerses,
      linkedSermonId: linkedSermonId ?? this.linkedSermonId,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isPinned: isPinned ?? this.isPinned,
      colorLabel: colorLabel ?? this.colorLabel,
      imagePaths: imagePaths ?? this.imagePaths,
      audioPath: audioPath ?? this.audioPath,
    );
  }
}

/// Alarm model for reminders
class Alarm {
  final String id;
  final String type; // daily_verse, study_session, prayer_reminder, sermon_live, streak_warning
  final int hour;
  final int minute;
  final List<int> repeatDays; // [0,1,2,3,4,5,6] for S M T W T F S
  final String? label;
  final String? soundPath;
  final bool isActive;
  final bool isEnabled; // User toggle
  final DateTime? lastTriggered;
  final DateTime? nextOccurrence;
  final int snoozeMinutes;

  Alarm({
    String? id,
    required this.type,
    required this.hour,
    required this.minute,
    this.repeatDays = const [],
    this.label,
    this.soundPath,
    this.isActive = true,
    this.isEnabled = true,
    this.lastTriggered,
    this.nextOccurrence,
    this.snoozeMinutes = 5,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'hour': hour,
      'minute': minute,
      'repeat_days': repeatDays,
      'label': label,
      'sound_path': soundPath,
      'is_active': isActive,
      'is_enabled': isEnabled,
      'last_triggered': lastTriggered?.toIso8601String(),
      'next_occurrence': nextOccurrence?.toIso8601String(),
      'snooze_minutes': snoozeMinutes,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      type: json['type'],
      hour: json['hour'],
      minute: json['minute'],
      repeatDays: (json['repeat_days'] as List?)?.cast<int>() ?? [],
      label: json['label'],
      soundPath: json['sound_path'],
      isActive: json['is_active'] ?? true,
      isEnabled: json['is_enabled'] ?? true,
      lastTriggered: json['last_triggered'] != null 
          ? DateTime.parse(json['last_triggered']) 
          : null,
      nextOccurrence: json['next_occurrence'] != null 
          ? DateTime.parse(json['next_occurrence']) 
          : null,
      snoozeMinutes: json['snooze_minutes'] ?? 5,
    );
  }

  Alarm copyWith({
    String? type,
    int? hour,
    int? minute,
    List<int>? repeatDays,
    String? label,
    String? soundPath,
    bool? isActive,
    bool? isEnabled,
    DateTime? lastTriggered,
    DateTime? nextOccurrence,
    int? snoozeMinutes,
  }) {
    return Alarm(
      id: id,
      type: type ?? this.type,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeatDays: repeatDays ?? this.repeatDays,
      label: label ?? this.label,
      soundPath: soundPath ?? this.soundPath,
      isActive: isActive ?? this.isActive,
      isEnabled: isEnabled ?? this.isEnabled,
      lastTriggered: lastTriggered ?? this.lastTriggered,
      nextOccurrence: nextOccurrence ?? this.nextOccurrence,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    );
  }

  /// Get human-readable repeat days
  String get repeatDaysLabel {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    if (repeatDays.isEmpty) return 'Once';
    if (repeatDays.length == 7) return 'Daily';
    if (repeatDays.length == 5 && !repeatDays.contains(0) && !repeatDays.contains(6)) {
      return 'Weekdays';
    }
    if (repeatDays.length == 2 && repeatDays.contains(0) && repeatDays.contains(6)) {
      return 'Weekends';
    }
    return repeatDays.map((d) => days[d]).join(', ');
  }

  /// Get next occurrence preview
  String getNextOccurrencePreview() {
    if (nextOccurrence == null) return '';
    final now = DateTime.now();
    final diff = nextOccurrence!.difference(now);
    
    if (diff.inDays > 0) {
      return 'Tomorrow, ${_formatTime()}';
    } else if (diff.inDays == 0) {
      return 'Today, ${_formatTime()}';
    }
    return _formatTime();
  }

  String _formatTime() {
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final ampm = hour >= 12 ? 'PM' : 'AM';
    return '$h:${minute.toString().padLeft(2, '0')} $ampm';
  }
}

/// Sermon model for sermon library
class Sermon {
  final String id;
  final String title;
  final String speaker;
  final String church;
  final String scripture;
  final int durationSeconds;
  final String type; // youtube, audio, video
  final String sourceUrl;
  final String? thumbnailUrl;
  final DateTime datePreached;
  final bool isFavorite;
  final bool isDownloaded;
  final String? localPath;
  final int progressSeconds;
  final List<String> notes; // Note IDs
  final DateTime addedAt;

  Sermon({
    String? id,
    required this.title,
    required this.speaker,
    required this.church,
    required this.scripture,
    required this.durationSeconds,
    required this.type,
    required this.sourceUrl,
    this.thumbnailUrl,
    required this.datePreached,
    this.isFavorite = false,
    this.isDownloaded = false,
    this.localPath,
    this.progressSeconds = 0,
    this.notes = const [],
    DateTime? addedAt,
  })  : id = id ?? const Uuid().v4(),
        addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'speaker': speaker,
      'church': church,
      'scripture': scripture,
      'duration_seconds': durationSeconds,
      'type': type,
      'source_url': sourceUrl,
      'thumbnail_url': thumbnailUrl,
      'date_preached': datePreached.toIso8601String(),
      'is_favorite': isFavorite,
      'is_downloaded': isDownloaded,
      'local_path': localPath,
      'progress_seconds': progressSeconds,
      'notes': notes,
      'added_at': addedAt.toIso8601String(),
    };
  }

  factory Sermon.fromJson(Map<String, dynamic> json) {
    return Sermon(
      id: json['id'],
      title: json['title'],
      speaker: json['speaker'],
      church: json['church'],
      scripture: json['scripture'],
      durationSeconds: json['duration_seconds'],
      type: json['type'],
      sourceUrl: json['source_url'],
      thumbnailUrl: json['thumbnail_url'],
      datePreached: DateTime.parse(json['date_preached']),
      isFavorite: json['is_favorite'] ?? false,
      isDownloaded: json['is_downloaded'] ?? false,
      localPath: json['local_path'],
      progressSeconds: json['progress_seconds'] ?? 0,
      notes: (json['notes'] as List?)?.cast<String>() ?? [],
      addedAt: DateTime.parse(json['added_at']),
    );
  }

  /// Get formatted duration
  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final seconds = durationSeconds % 60;
    
    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get playback progress percentage
  double get progressPercentage {
    if (durationSeconds == 0) return 0.0;
    return (progressSeconds / durationSeconds).clamp(0.0, 1.0);
  }

  Sermon copyWith({
    String? title,
    String? speaker,
    String? church,
    String? scripture,
    int? durationSeconds,
    String? type,
    String? sourceUrl,
    String? thumbnailUrl,
    DateTime? datePreached,
    bool? isFavorite,
    bool? isDownloaded,
    String? localPath,
    int? progressSeconds,
    List<String>? notes,
  }) {
    return Sermon(
      id: id,
      title: title ?? this.title,
      speaker: speaker ?? this.speaker,
      church: church ?? this.church,
      scripture: scripture ?? this.scripture,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      type: type ?? this.type,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      datePreached: datePreached ?? this.datePreached,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localPath: localPath ?? this.localPath,
      progressSeconds: progressSeconds ?? this.progressSeconds,
      notes: notes ?? this.notes,
      addedAt: addedAt,
    );
  }
}

/// Transcript model for speech-to-text results
class Transcript {
  final String id;
  final String title;
  final String rawText;
  final String editedText;
  final String? linkedSermonId;
  final String? linkedNoteId;
  final String language;
  final String mode; // on_device or cloud
  final DateTime recordedAt;
  final int durationSeconds;
  final bool isSaved;

  Transcript({
    String? id,
    required this.title,
    required this.rawText,
    required this.editedText,
    this.linkedSermonId,
    this.linkedNoteId,
    required this.language,
    required this.mode,
    DateTime? recordedAt,
    required this.durationSeconds,
    this.isSaved = false,
  })  : id = id ?? const Uuid().v4(),
        recordedAt = recordedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'raw_text': rawText,
      'edited_text': editedText,
      'linked_sermon_id': linkedSermonId,
      'linked_note_id': linkedNoteId,
      'language': language,
      'mode': mode,
      'recorded_at': recordedAt.toIso8601String(),
      'duration_seconds': durationSeconds,
      'is_saved': isSaved,
    };
  }

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      id: json['id'],
      title: json['title'],
      rawText: json['raw_text'],
      editedText: json['edited_text'],
      linkedSermonId: json['linked_sermon_id'],
      linkedNoteId: json['linked_note_id'],
      language: json['language'],
      mode: json['mode'],
      recordedAt: DateTime.parse(json['recorded_at']),
      durationSeconds: json['duration_seconds'],
      isSaved: json['is_saved'] ?? false,
    );
  }
}

/// Highlight model for verse highlights
class Highlight {
  final String id;
  final String verseReference;
  final String translation;
  final String color;
  final String? note;
  final DateTime createdAt;

  Highlight({
    String? id,
    required this.verseReference,
    required this.translation,
    required this.color,
    this.note,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verse_reference': verseReference,
      'translation': translation,
      'color': color,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'],
      verseReference: json['verse_reference'],
      translation: json['translation'],
      color: json['color'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// Reading plan progress model
class ReadingPlanProgress {
  final String id;
  final String planType; // canonical, chronological, thematic
  final String? planName;
  final int currentDay;
  final int totalDays;
  final String currentReading;
  final List<String>? readingsCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isActive;

  ReadingPlanProgress({
    String? id,
    required this.planType,
    this.planName,
    required this.currentDay,
    required this.totalDays,
    required this.currentReading,
    this.readingsCompleted,
    DateTime? startedAt,
    this.completedAt,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        startedAt = startedAt ?? DateTime.now();

  double get progressPercentage {
    return (currentDay / totalDays).clamp(0.0, 1.0);
  }

  int get daysRemaining => totalDays - currentDay;
}
