import 'package:flutter/material.dart';

import '/util/theme.dart';
import '/util/persistence.dart';
import '/preferences.dart';

class AppState extends ChangeNotifier {
  late ProjectTheme projectTheme; // Updated in App.build.
  
  final preferences = Preferences();
  late final Future<void> preferencesLoaded;
  
  AppState(AppDatabase database) {
    preferencesLoaded = database.getUserPreferences().then((userPreferences) {
      preferences.appState = this;
      preferences.colorScheme = ColorScheme.fromSeed(
        seedColor: Color(userPreferences.seedColor),
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      );
      
      debugPrint('''
Default preferences from app database:
Color Scheme: ${preferences.colorScheme}
''');
    });
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
