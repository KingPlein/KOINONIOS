/// App-wide constants for Syntrophe Bible Study App
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Syntrophe';
  static const String appTagline = 'Growing together in the Word';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'syntrophe.db';
  static const int databaseVersion = 1;

  // Hive Boxes
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
  static const String authBox = 'auth';

  // API Endpoints
  static const String bibleApiComBaseUrl = 'https://bible-api.com';
  static const String helloAoBaseUrl = 'https://bibles.helloao.org/api/v1';
  static const String esvApiBaseUrl = 'https://api.esv.org';

  // Supported Translations
  static const List<String> supportedTranslations = ['KJV', 'WEB', 'BSB', 'ASV', 'ESV'];
  static const String defaultTranslation = 'KJV';

  // Copyright Notices
  static const String esvCopyrightNotice = 
      'ESV Bible text copyright 2001 by Crossway. Used by permission. All rights reserved.';

  // Notification Channels
  static const String dailyVerseChannelId = 'daily_verse_channel';
  static const String alarmChannelId = 'alarm_channel';
  static const String prayerReminderChannelId = 'prayer_reminder_channel';
  static const String sermonAlertChannelId = 'sermon_alert_channel';

  // Alarm Defaults
  static const int defaultDailyVerseHour = 8;
  static const int defaultDailyVerseMinute = 0;
  static const int streakWarningHour = 20; // 8 PM
  static const int streakWarningMinute = 0;

  // Snooze Options (minutes)
  static const List<int> snoozeOptions = [5, 10, 15];

  // Playback Speeds
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  // Sleep Timer Options (minutes)
  static const List<int> sleepTimerOptions = [5, 10, 15, 30, 45, 60];

  // Font Sizes
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeExtraLarge = 20.0;

  // Line Heights
  static const double lineHeightScripture = 1.6;
  static const double lineHeightUI = 1.4;

  // Touch Target
  static const double minTouchTarget = 48.0;

  // Animation Durations (ms)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int themeAnimationDuration = 300;

  // Memory Limits
  static const int memoryTargetMB = 150;

  // Image Compression
  static const int maxImageSizeKB = 500;

  // Transcription
  static const Duration transcriptionLatencyMs = Duration(milliseconds: 300);
  static const double onDeviceAccuracy = 0.875; // ~85-90%
  static const double cloudAccuracy = 0.965; // ~95-98%
  static const double whisperCostPerMinute = 0.006; // USD

  // Reading Plans
  static const List<String> readingPlanTypes = [
    'canonical',
    'chronological',
    'thematic'
  ];

  // Note Types
  static const List<String> noteTypes = [
    'general',
    'sermon',
    'verse_study',
    'prayer_list'
  ];

  // Highlight Colors
  static const List<String> highlightColors = [
    'yellow',
    'green',
    'blue',
    'purple',
    'red',
    'orange'
  ];

  // Sort Options for Notes
  static const List<String> noteSortOptions = [
    'recently_updated',
    'date_created',
    'title_az'
  ];

  // Repeat Days for Alarms
  static const List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
}
