import 'package:flutter/material.dart';

import '/initialization/init.dart';
import '/util/theme.dart';
import '/util/persistence.dart';
import '/preferences.dart';

class AppState extends ChangeNotifier {
  late ProjectTheme projectTheme; // Updated in App.build.
  
  late final Future<InitializationState> initializationComplete;
  
  final preferences = Preferences();
  late final SessionData sessionInfo;
  
  AppState(AppDatabase database) {
    initializationComplete = initializeApp(database, this);
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
