import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/util/persistence.dart';

class Global {
  static const appTitle = kDebugMode ? 'DEBUG | Therapy Chatbot' : 'Therapy Chatbot';
  
  static final defaultSeedColor = const Color.fromARGB(255, 100, 149, 237).value;
  static final defaultBasePreferences = PreferencesCompanion(
    name: const Value('default'),
    seedColor: Value(defaultSeedColor),
  );
  static final defaultUserPreferences = PreferencesCompanion(
    name: const Value('user'),
    seedColor: Value(defaultSeedColor),
  );
  
  static Widget loadingScreen(Color backgroundColor, Color indicatorColor) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(indicatorColor),
        ),
      ),
    );
  }
}
