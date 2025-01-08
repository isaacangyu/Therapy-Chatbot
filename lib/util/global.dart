import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/util/persistence.dart';

class Global {
  static const appVersion = '1.0.0+1';
  
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
  
  // static const initBaseUrl = 'https://raw.githubusercontent.com/isaacangyu/Therapy-Chatbot/refs/heads/staging/api';
  static const initBaseUrl = 'http://localhost:5000/api';
  static const forgotPasswordInfoUrl = '$initBaseUrl/forgot_password_info.json';
  static const latestAppVersionUrl = '$initBaseUrl/latest_app_version.json';
  static const backendBaseUrl = '$initBaseUrl/base_url.json';
  
  static const certBaseUrl = 'http://localhost:5000/cert/${kDebugMode ? 'test' : 'prod'}';
  static const publicKeyUrl = '$certBaseUrl/public/public.pem';
  
  static bool offline(BuildContext context) {
    if (online) {
      return false;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This function isn't available offline.")
      )
    );
    return true;
  }
  static late bool online;
  static String? baseURL;
  static String? verificationUrl;
  static String? createAccountUrl;
  static String? resetPasswordUrl;
}
