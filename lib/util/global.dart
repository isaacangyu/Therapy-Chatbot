import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/util/persistence.dart';

class API {
  static late String initBaseUrl;
  static String? baseUrl, wsBaseUrl;

  static const forgotPasswordInfo = 'api/forgot_password_info.json';
  static const latestAppVersion = 'api/latest_app_version.json';
  static var backendBase = 'api/base_url${Global.androidDebugMode ? "_debug_android" : ""}.json';
  static const publicKey = 'cert/${kDebugMode ? 'test' : 'prod'}/public/public.pem';
  
  static const createAccount = 'account/create/';
  static const resetPassword = 'account/reset_password/';
  static const loginPassword = 'account/login/password/';
  static const loginToken = 'account/login/token/';
  
  static const wsChatbot = 'ws/chatbot/';
}

class Global {
  static late String appVersion;
  static var androidDebugMode = kDebugMode && defaultTargetPlatform == TargetPlatform.android;
  static const rsaKeySizeBits = 3072;
  static const rsaKeySizeBytes = rsaKeySizeBits ~/ 8;
  
  static const appTitle = kDebugMode ? '[DEBUG] Therapy Chatbot' : 'Therapy Chatbot';
  
  static final defaultSeedColor = const Color.fromARGB(255, 100, 180, 100).toARGB32();
  static final defaultUserPreferences = PreferencesCompanion(
    seedColor: Value(defaultSeedColor),
  );
  
  static const largeScreenThreshold = 960.0;
  static const mediumScreenThreshold = 640.0;
  static const navigationRailExtendedThreshold = 800.0;
}
