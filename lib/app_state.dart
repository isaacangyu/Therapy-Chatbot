import 'package:flutter/material.dart';

import 'initialization/initialization.dart';
import '/util/theme.dart';
import '/util/persistence.dart';
import '/preferences.dart';
import '/session.dart';

class AppState extends ChangeNotifier {
  late ProjectTheme projectTheme;
  
  late final Future<InitializationState> initializationComplete;
  
  final preferences = Preferences();
  final session = Session();
  
  AppState(AppDatabase database) {
    initializationComplete = initializeApp(database, this);
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
