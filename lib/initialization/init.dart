import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/app_state.dart';
import '/util/global.dart';
import '/util/persistence.dart';

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
/// 
Future<InitializationState> initializeApp(AppDatabase database, AppState appState) async {
  try {
    var userPreferences = await database.getUserPreferences();
    appState.preferences.appState = appState;
    appState.preferences.colorScheme = ColorScheme.fromSeed(
      seedColor: Color(userPreferences.seedColor),
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    
    debugPrint('''
Default preferences from app database:
Color Scheme: ${appState.preferences.colorScheme}
''');
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      'Failed to load app preferences.'
    );
  }
  
  var latestAppVersion = await fetchLatestAppVersion();
  if (latestAppVersion != null && latestAppVersion != Global.appVersion) {
    return InitializationState(
      false,
      'An update is availabe. Please update to version $latestAppVersion.'
    );
  }
  
  try {
    appState.sessionInfo = await database.getSession();
    
    debugPrint('''
Session info:
Token: ${appState.sessionInfo.token}
Logged in: ${appState.sessionInfo.loggedIn}
''');
  } catch (e) {
    debugPrint(e.toString());
    return InitializationState(
      false,
      'Failed to load session info.'
    );
  }
  var backendBaseUrl = await fetchBackendBaseUrl();
  if (backendBaseUrl == null && !appState.sessionInfo.loggedIn) {
    return InitializationState(
      false,
      'Unable to reach online services. Please check your internet connection.'
    );
  }
  
  if (latestAppVersion == null && backendBaseUrl != null) {
    return InitializationState(
      false,
      'Unable to resolve conflicting information.'
    );
  }
  
  debugPrint('Latest App Version: $latestAppVersion');
  debugPrint('Current App Version: ${Global.appVersion}');
  debugPrint('Backend Base URL: $backendBaseUrl');
  
  Global.baseURL = backendBaseUrl;
  
  // Insert some artificial delay.
  // Otherwise, the splash screen image is "janky".
  await Future.delayed(const Duration(seconds: 2));
  
  return backendBaseUrl == null ? InitializationState(
    true,
    'You are in offline mode.'
  ) : InitializationState(
    true,
    ''
  );
}

Future<String?> fetchLatestAppVersion() async {
  try {
    http.Response response;
    response = await http.get(Uri.parse(Global.latestAppVersionUrl));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['version'];
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

Future<String?> fetchBackendBaseUrl() async {
  try {
    http.Response response;
    response = await http.get(Uri.parse(Global.backendBaseUrl));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['url'];
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

class InitializationState {
  InitializationState(this.success, this.message);
  
  bool success;
  String message;
}
