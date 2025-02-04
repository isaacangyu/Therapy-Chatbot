import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'initialization/initialization.dart';
import '/util/persistence.dart';
import '/preferences.dart';
import '/session.dart';

class AppState extends ChangeNotifier {
  late final Future<InitializationState> initializationComplete;
  
  final preferences = Preferences();
  final session = Session();
  
  AppState(AppDatabase database, FlutterSecureStorage secureStorage) {
    initializationComplete = initializeApp(this, database, secureStorage);
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
