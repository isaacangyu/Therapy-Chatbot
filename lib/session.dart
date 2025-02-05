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
  
  void setToken(String? token) {
    this.token = token;
    secureStorage.write(key: _SecureStorageKeys.token, value: token);
  }
  
  void setLoggedIn(bool loggedIn) {
    this.loggedIn = loggedIn;
    secureStorage.write(key: _SecureStorageKeys.loggedIn, value: loggedIn ? '1' : '0');
  }
}

class _SecureStorageKeys {
  static const token = 'token';
  static const loggedIn = 'logged_in';
}
