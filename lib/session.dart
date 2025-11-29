import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/util/crypto.dart';

import '/app_state.dart';

class Session {
  late final AppState appState;
  late bool online;
  
  late FlutterSecureStorage secureStorage;
  String? _email, _token;
  late bool _loggedIn;
  
  Future<void> initCrypto() async {
    _email = await secureStorage.read(key: _SecureStorageKeys.email);
    _token = await secureStorage.read(key: _SecureStorageKeys.token);
    _loggedIn = await secureStorage.read(key: _SecureStorageKeys.loggedIn) == '1';
    var encryptionKey = await secureStorage.read(key: _SecureStorageKeys.encryptionKey);
    
    if (_loggedIn && encryptionKey != null) {
      initClientSideEncrypter(encryptionKey);
    }
  }
  
  void setOnline(bool state) {
    online = state;
    appState.notifyListeners();
  }
  
  // Note: Writes may fail if multiple writes are attempted concurrently.
  
  String? getEmail() {
    return _email;
  }
  Future<void> setEmail(String? email) async {
    _email = email;
    await secureStorage.write(key: _SecureStorageKeys.email, value: email);
  }
  
  String? getToken() {
    return _token;
  }
  Future<void> setToken(String? token) async {
    _token = token;
    await secureStorage.write(key: _SecureStorageKeys.token, value: token);
  }
  
  bool getLoggedIn() {
    return _loggedIn;
  }
  Future<void> setLoggedIn(bool loggedIn) async {
    _loggedIn = loggedIn;
    await secureStorage.write(key: _SecureStorageKeys.loggedIn, value: loggedIn ? '1' : '0');
  }
  
  Future<void> setEncryptionKey(String? encryptionKeyBase64) async {
    await secureStorage.write(key: _SecureStorageKeys.encryptionKey, value: encryptionKeyBase64);
  }
  
  bool offline(BuildContext context) {
    if (online) {
      return false;
    }
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This function isn't available offline.")
        )
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}

class _SecureStorageKeys {
  static const email = 'email';
  static const token = 'token';
  static const loggedIn = 'logged_in';
  static const encryptionKey = "encryption_key";
}
