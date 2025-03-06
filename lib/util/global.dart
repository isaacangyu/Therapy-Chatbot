import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/util/persistence.dart';

class API {
  static late String initBaseUrl;
  static String? baseUrl;

  static const forgotPasswordInfo = 'api/forgot_password_info.json';
  static const latestAppVersion = 'api/latest_app_version.json';
  static const backendBase = 'api/base_url.json';
  static const publicKey = 'cert/${kDebugMode ? 'test' : 'prod'}/public/public.pem';
  
  static const createAccount = 'account/create/';
  static const resetPassword = 'account/reset_password/';
  static const loginPassword = 'account/login/password/';
  static const loginToken = 'account/login/token/';
}

class Global {
  static late String appVersion;
  
  static const appTitle = kDebugMode ? '[DEBUG] Therapy Chatbot' : 'Therapy Chatbot';
  
  static final defaultSeedColor = const Color.fromARGB(255, 100, 149, 237).value;
  static final defaultUserPreferences = PreferencesCompanion(
    seedColor: Value(defaultSeedColor),
  );
    
  static bool offline(BuildContext context, bool online) {
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
}
