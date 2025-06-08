import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/app_state.dart';
import '/util/global.dart';
import '/util/persistence.dart';
import '/util/network.dart';

/// App Initialization Procedure
/// 
/// 1. Load configuration data from `config.json`.
///    Halt initialization on failure.
/// 2. Retrieve user preferences from app database.
///    In the event of an exception, such as in the case of 
///    database corruption, halt initialization.
///    Normal operation of the app beyond this point 
///    may result in further database corruption.
///    Otherwise, continue initialization.
/// 3. Retrieve cryptographic information from secure storage.
///    Apply the same principle as when loading preferences.
/// 4. (A) Fetch latest app version and (B) backend URL.
///    (Regard network errors and JSON errors to have similar effect.)
///    - In the case that A succeeds, regardless of B:
///    > If there's an update, halt initialization.
///    > If there is not an update, continue initialization.
///    - In the case that B fails, regardless of A:
///    > If the user is already logged in, continue initialization.
///    Normal operation of the app in this case is acceptable 
///    given that all functions are designed to handle this scenario.
///    > If the user is not logged in, halt initialization.
///    - In the case that A fails and B succeeds, halt initialization.
///      There may be an update required.
/// 5. If and only if the user will be online, 
///    fetch cryptographic keys. Halt initialization on failure.
///    Also generate a symmetric encryption key to be used 
///    for decrypting HTTP response data.
/// 6. If and only if the user will be online and is already logged in, 
///    test the validity of the session token via request to 
///    the main backend. If the session token is invalid, clear it 
///    and set the user as logged out. Otherwise, do nothing.
/// 
Future<InitializationState> initializeApp(
  AppState appState,
  AppDatabase database,
  FlutterSecureStorage secureStorage
) async {
  appState.preferences.appState = appState;
  appState.session.appState = appState;

  try {
    var config = jsonDecode(await rootBundle.loadString('app_assets/config.json'));
    Global.appVersion = config['app_version'];
    API.initBaseUrl = config['init_base_url${Global.androidDebugMode ? "_debug_android" : ""}'];
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      message: 'Failed to load app configuration.'
    );
  }
  
  try {
    appState.preferences.data = await database.getUserPreferences();
    appState.preferences.colorScheme = ColorScheme.fromSeed(
      seedColor: Color(appState.preferences.data.seedColor),
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      message: 'Failed to load app preferences.'
    );
  }
  
  try {
    appState.session.secureStorage = secureStorage;
    await appState.session.initCrypto();
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      message: 'Failed to load session info. Try clearing the app\'s cache.'
    );
  }
  
  var latestAppVersion = await _fetchLatestAppVersion();
  if (latestAppVersion != null && latestAppVersion != Global.appVersion) {
    return InitializationState(
      false,
      message: 'An update is availabe. Please update to version $latestAppVersion.'
    );
  }
  
  var backendBaseUrls = await _fetchBackendBaseUrl();
  if (backendBaseUrls == null && !appState.session.getLoggedIn()) {
    return InitializationState(
      false,
      message: 'Unable to reach online services. Please check your internet connection.'
    );
  }
  
  if (latestAppVersion == null && backendBaseUrls != null) {
    return InitializationState(
      false,
      message: 'Unable to resolve conflicting information.'
    );
  }
  
  if (backendBaseUrls != null) {
    appState.session.online = true;
    API.baseUrl = backendBaseUrls.baseUrl;
    API.wsBaseUrl = backendBaseUrls.wsBaseUrl;
    
    var keysLoaded = await loadKeys();
    if (!keysLoaded) {
      return InitializationState(
        false,
        message: 'Missing security features.'
      );
    }
  } else {
    appState.session.online = false;
  }
  
  if (appState.session.online && appState.session.getLoggedIn()) {
    var tokenValid = await _validateSessionToken(
      appState.session.getEmail(), appState.session.getToken()
    );
    if (!tokenValid) {
      try {
        await appState.session.setEmail(null);
        await appState.session.setToken(null);
        await appState.session.setLoggedIn(false);
      } catch (e) {
        debugPrint(e.toString());
        return InitializationState(
          false,
          message: 'Failed to automatically log out. Try clearing the app\'s cache.'
        );
      }
    }
  }
  
  debugPrint('''
Default preferences from app database:
Color Scheme Seed: ${appState.preferences.colorScheme.primaryContainer}

Session info:
Email: ${appState.session.getEmail()}
Token: ${appState.session.getToken()}
Logged in: ${appState.session.getLoggedIn()}

Latest App Version: $latestAppVersion
Current App Version: ${Global.appVersion}
Initialization Base URL: ${API.initBaseUrl}
Backend Base URL: ${backendBaseUrls?.baseUrl}
WebSocket Backend Base URL: ${backendBaseUrls?.wsBaseUrl}
''');
  
  // Insert some artificial delay.
  // Otherwise, the splash screen image is "janky".
  if (!kDebugMode) {
    await Future.delayed(const Duration(seconds: 2));
  }
  
  return InitializationState(true);
}

Future<String?> _fetchLatestAppVersion() {
  return httpGetApi(
    API.latestAppVersion,
    (json) => json['version'],
    () => null,
  );
}

class _BaseUrls {
  _BaseUrls(this.baseUrl, this.wsBaseUrl);
  
  String baseUrl;
  String wsBaseUrl;
}
Future<_BaseUrls?> _fetchBackendBaseUrl() {
  return httpGetApi(
    API.backendBase,
    (json) => _BaseUrls(json['url'], json['ws_url']),
    () => null,
  );
}

Future<bool> _validateSessionToken(String? email, String? token) async {
  if (email == null || token == null) {
    return false;
  }
  
  return httpPostSecure(
    API.loginToken,
    includeToken(email, token, {}),
    (json) => json['valid'],
    (_) => false,
  );
}

class InitializationState {
  InitializationState(this.success, {this.message});
  
  bool success;
  String? message;
}
