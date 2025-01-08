import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/app_state.dart';
import '/util/global.dart';
import '/util/persistence.dart';
import '/util/network.dart';

/// App Initialization Procedure
/// 
/// 1. Retrieve user preferences from app database.
///    In the event of an exception, such as in the case of 
///    database corruption, halt initialization.
///    Normal operation of the app beyond this point 
///    may result in further database corruption.
///    Otherwise, continue initialization.
/// 2. (A) Fetch latest app version and (B) backend URL.
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
/// 3. If and only if the user will be online, 
///    fetch cryptographic keys. Halt initialization on failure.
/// 
Future<InitializationState> initializeApp(AppDatabase database, AppState appState) async {
  try {
    var userPreferences = await database.getUserPreferences();
    appState.preferences.appState = appState;
    appState.preferences.colorScheme = ColorScheme.fromSeed(
      seedColor: Color(userPreferences.seedColor),
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      message: 'Failed to load app preferences.'
    );
  }
  
  var latestAppVersion = await fetchLatestAppVersion();
  if (latestAppVersion != null && latestAppVersion != Global.appVersion) {
    return InitializationState(
      false,
      message: 'An update is availabe. Please update to version $latestAppVersion.'
    );
  }
  
  try {
    appState.sessionInfo = await database.getSession();
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      message: 'Failed to load session info.'
    );
  }
  var backendBaseUrl = await fetchBackendBaseUrl();
  if (backendBaseUrl == null && !appState.sessionInfo.loggedIn) {
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
Color Scheme Seed: ${appState.preferences.colorScheme?.primaryContainer}

Session info:
Token: ${appState.sessionInfo.token}
Logged in: ${appState.sessionInfo.loggedIn}

Latest App Version: $latestAppVersion
Current App Version: ${Global.appVersion}
Backend Base URL: $backendBaseUrl
''');
  
  if (backendBaseUrl != null) {
    Global.baseURL = backendBaseUrl;
    Global.online = true;
    Global.verificationUrl = '$backendBaseUrl/verify';
    Global.resetPasswordUrl = '$backendBaseUrl/account/reset_password';
    Global.createAccountUrl = '$backendBaseUrl/account/create';
    
    var keysLoaded = await loadKeys();
    if (!keysLoaded) {
      return InitializationState(
        false,
        message: 'Missing security features.'
      );
    }
  } else {
    Global.online = false;
  }
    
  // Insert some artificial delay.
  // Otherwise, the splash screen image is "janky".
  if (!kDebugMode) {
    await Future.delayed(const Duration(seconds: 2));
  }
  
  return InitializationState(true);
}

Future<String?> fetchLatestAppVersion() {
  return httpGetApi(
    Global.latestAppVersionUrl,
    (json) => json['version'],
    () => null,
  );
}

Future<String?> fetchBackendBaseUrl() {
  return httpGetApi(
    Global.backendBaseUrl,
    (json) => json['url'],
    () => null,
  );
}

class InitializationState {
  InitializationState(this.success, {this.message});
  
  bool success;
  String? message;
}
