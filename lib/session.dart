import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/app_state.dart';

class Session {
  late final AppState appState;
  late bool online;
  
  late FlutterSecureStorage secureStorage;
  String? token;
  late bool loggedIn;
  
  Future<void> initCrypto() async {
    token = await secureStorage.read(key: _SecureStorageKeys.token);
    loggedIn = await secureStorage.read(key: _SecureStorageKeys.loggedIn) == '1';
  }
  
  void setOnline(bool state) {
    online = state;
    appState.notifyListeners();
  }
  
  Future<void> setToken(String? token) async {
    this.token = token;
    await secureStorage.write(key: _SecureStorageKeys.token, value: token);
  }
  
  Future<void> setLoggedIn(bool loggedIn) async {
    this.loggedIn = loggedIn;
    await secureStorage.write(key: _SecureStorageKeys.loggedIn, value: loggedIn ? '1' : '0');
  }
}

class _SecureStorageKeys {
  static const token = 'token';
  static const loggedIn = 'logged_in';
}
