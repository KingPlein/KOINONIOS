import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/repositories/bible_repository.dart';
import '../../services/connectivity_service.dart';
import '../app.dart';

/// Main entry point for Syntrophe Bible Study App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme provider before first frame
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  // Initialize Bible repository
  final bibleRepository = BibleRepository();

  // Initialize connectivity service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();

  // Update repository with initial online status
  bibleRepository.updateOnlineStatus(await connectivityService.isConnected());

  // Listen to connectivity changes
  connectivityService.addListener(() {
    bibleRepository.updateOnlineStatus(connectivityService.isConnected());
  });

  runApp(
    SyntropheApp(
      themeProvider: themeProvider,
      bibleRepository: bibleRepository,
    ),
  );
}
