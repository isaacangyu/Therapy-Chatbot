import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
/// 3. Retrieve user session from app database.
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
/// 
Future<InitializationState> initializeApp(AppDatabase database, AppState appState) async {
  appState.preferences.appState = appState;
  appState.session.appState = appState;

  try {
    var config = jsonDecode(await rootBundle.loadString('app_assets/config.json'));
    Global.appVersion = config['app_version'];
    API.initBaseUrl = config['init_base_url'];
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
    appState.session.data = await database.getSession();
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      message: 'Failed to load session info.'
    );
  }
  
  var latestAppVersion = await _fetchLatestAppVersion();
  if (latestAppVersion != null && latestAppVersion != Global.appVersion) {
    return InitializationState(
      false,
      message: 'An update is availabe. Please update to version $latestAppVersion.'
    );
  }
  
  var backendBaseUrl = await _fetchBackendBaseUrl();
  if (backendBaseUrl == null && !appState.session.data.loggedIn) {
    return InitializationState(
      false,
      message: 'Unable to reach online services. Please check your internet connection.'
    );
  }
  
  if (latestAppVersion == null && backendBaseUrl != null) {
    return InitializationState(
      false,
      message: 'Unable to resolve conflicting information.'
    );
  }
  
  debugPrint('''
Default preferences from app database:
Color Scheme Seed: ${appState.preferences.colorScheme.primaryContainer}

Session info:
Token: ${appState.session.data.token}
Logged in: ${appState.session.data.loggedIn}

Latest App Version: $latestAppVersion
Current App Version: ${Global.appVersion}
Initialization Base URL: ${API.initBaseUrl}
Backend Base URL: $backendBaseUrl
''');
  
  if (backendBaseUrl != null) {
    appState.session.online = true;
    API.baseUrl = backendBaseUrl;
    
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

Future<String?> _fetchBackendBaseUrl() {
  return httpGetApi(
    API.backendBase,
    (json) => json['url'],
    () => null,
  );
}

class InitializationState {
  InitializationState(this.success, {this.message});
  
  bool success;
  String? message;
}
