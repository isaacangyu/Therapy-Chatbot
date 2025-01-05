import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/util/persistence.dart';

class Global {
  static const appTitle = kDebugMode ? 'DEBUG | Therapy Chatbot' : 'Therapy Chatbot';
  
  static final defaultSeedColor = const Color.fromARGB(255, 100, 149, 237).value;
  static final defaultBasePreferences = PreferencesCompanion(
    name: const drift.Value('default'),
    seedColor: drift.Value(defaultSeedColor),
  );
  static final defaultUserPreferences = PreferencesCompanion(
    name: const drift.Value('user'),
    seedColor: drift.Value(defaultSeedColor),
  );
  
  static Widget loadingScreen(Color backgroundColor, Color indicatorColor, {Widget? child}) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(indicatorColor),
            ),
            const SizedBox(height: 10),
            child ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
  
  // static const apiBaseUrl = 'https://raw.githubusercontent.com/isaacangyu/Therapy-Chatbot/refs/heads/staging/api';
  static const apiBaseUrl = 'http://localhost:5000/api';
  static const forgotPasswordInfoUrl = '$apiBaseUrl/forgot_password_info.json';
  
  static const baseURL = 'http://localhost:8000';
}
