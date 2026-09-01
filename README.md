# Syntrophe - Bible Study Partner App

**Growing together in the Word**

A premium offline-first Android Bible study companion built with Flutter.

## Features

### 📖 Bible Reading
- **Multi-translation support**: KJV, WEB, BSB, ASV, ESV (with proper attribution)
- **Offline-first caching**: Verses cached locally for offline access
- **Fuzzy reference matching**: "jn 316" → John 3:16
- **Verse-by-verse display**: Tap any verse for actions
- **Daily Verse**: Algorithmic selection from curated list
- **Reading plans**: Canonical, chronological, thematic

### 📝 Note-Taking
- **Rich-text journal**: Markdown support with formatting
- **Scripture auto-linking**: Type "John 3:16" becomes tappable link
- **Tagging system**: Auto-suggest, filter by tag
- **Attachments**: Images (<500KB compressed), audio recordings
- **Sermon linking**: Link notes to specific sermons
- **Export**: PDF, Markdown, plain text

### 🎙️ Transcription
- **Two-tier speech-to-text**: 
  - On-device (default, ~87% accuracy, 100% private)
  - Cloud Whisper API (optional, ~96% accuracy)
- **Live waveform visualization**
- **Auto scripture detection** in transcripts
- **Speaker labels** (manual or auto-diarization)

### 🎥 Sermon Library
- **YouTube embed** (primary source)
- **Audio podcast RSS feeds** (downloadable for offline)
- **Playback controls**: Speed adjustment, sleep timer, PiP
- **In-player note-taking**: Timestamp insertion, overlay mode
- **Progress tracking**: Resume where you left off

### ⏰ Alarm & Reminder System
- **Daily Verse alarm**: Recurring notification at user-set time
- **Study session alarms**: Custom schedule (e.g., Mon/Wed/Fri 6AM)
- **Prayer reminders**: Customizable labels
- **Streak warnings**: Fires at 8 PM if no app open
- **Persist across reboots**: Uses RECEIVE_BOOT_COMPLETED

### 🎨 Theme System
- **Light/Dark/System modes**
- **Zero-flash theme loading**: Loads from Hive before first frame
- **300ms crossfade animation** on theme switch
- **All screens respect theme**: Dialogs, bottom sheets, media players

## Tech Stack

- **Framework**: Flutter 3.24+ (Dart)
- **State Management**: Riverpod + BLoC pattern
- **Local Database**: SQLite (drift)
- **Local Cache**: Hive
- **Video**: video_player + chewie + youtube_player_flutter
- **Audio**: just_audio + audio_service
- **Speech-to-Text**: speech_to_text + Whisper API fallback
- **Notifications**: flutter_local_notifications + android_alarm_manager_plus
- **HTTP**: dio + retrofit
- **DI**: get_it + injectable
- **Architecture**: Clean Architecture, Repository pattern

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App-wide constants
│   ├── theme/           # Theme configuration & provider
│   ├── utils/           # Utility functions
│   └── routes/          # Navigation routes
├── data/
│   ├── models/          # Data models (entities, DTOs)
│   ├── database/        # Drift database schema
│   ├── repositories/    # Repository implementations
│   └── sources/
│       ├── local/       # Local data sources (SQLite, Hive)
│       └── remote/      # Remote API services
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic use cases
├── presentation/
│   ├── providers/       # State providers (Riverpod/BLoC)
│   ├── screens/         # UI screens
│   │   ├── home/
│   │   ├── bible/
│   │   ├── notes/
│   │   ├── sermons/
│   │   ├── transcribe/
│   │   ├── settings/
│   │   └── onboarding/
│   └── widgets/         # Reusable widgets
└── services/            # App services (connectivity, notifications)
```

## Getting Started

### Prerequisites
- Flutter SDK 3.24+
- Android Studio / VS Code
- Android SDK (API 24+/Android 7.0+)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code (for drift, injectable, etc.):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Build Release APK/AAB

```bash
# Generate release APK
flutter build apk --release

# Generate AAB for Play Store
flutter build appbundle --release
```

## Permissions

The app requests the following permissions:

| Permission | Purpose | Runtime? |
|------------|---------|----------|
| INTERNET | API calls, streaming | No |
| ACCESS_NETWORK_STATE | Offline detection | No |
| RECEIVE_BOOT_COMPLETED | Restore alarms after reboot | No |
| WAKE_LOCK | Alarm reliability | No |
| VIBRATE | Alarm vibration | No |
| SCHEDULE_EXACT_ALARM | Precise timing (Android 12+) | Yes |
| RECORD_AUDIO | Transcription, voice notes | Yes |
| READ_EXTERNAL_STORAGE | Import images/audio | Yes |
| POST_NOTIFICATIONS | Daily verse, alarms (Android 13+) | Yes |

## API Integration

### Bible APIs
- **Primary**: bible-api.com (KJV, WEB, ASV, BBE) - 15 req/30s
- **Secondary**: bibles.helloao.org (KJV, WEB, BSB) - MIT, no limits
- **ESV**: api.esv.org (requires API key, non-commercial only)

### Copyright Notices
- **ESV**: Must display "ESV Bible text copyright 2001 by Crossway. Used by permission. All rights reserved."
- **AMPC**: EXCLUDED (copyrighted, requires paid license)

## Color System

### Light Mode
- Background: `#F8F6F3`
- Surface/Card: `#FFFFFF`
- Primary: `#B85C38`
- Secondary: `#2A9D8F`
- Text Primary: `#1D1D1D`
- Text Secondary: `#6B6B6B`

### Dark Mode
- Background: `#0F0F1A`
- Surface/Card: `#1A1A2E`
- Primary: `#E07A5F`
- Secondary: `#48CAE4`
- Text Primary: `#F0F0F0`
- Text Secondary: `#9CA3AF`

## Typography

- **Scripture**: Crimson Text (serif), line-height 1.6
- **UI**: Inter (sans-serif), line-height 1.4
- **Font sizes**: Small (14px), Medium (16px), Large (18px), Extra Large (20px)

## Testing

```bash
# Run unit tests
flutter test test/unit/

# Run widget tests
flutter test test/widget/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Acknowledgments

- Bible texts from public domain sources
- Built with Flutter and amazing open-source packages

---

**Syntrophe** (Greek: σύντροφος — companionship, fellowship)
