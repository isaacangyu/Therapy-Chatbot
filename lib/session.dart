import '/app_state.dart';

class Session {
  late final AppState appState;
  late bool online;
  
  String? token;
  late bool loggedIn;
  
  void setOnline(bool state) {
    online = state;
    appState.notifyListeners();
  }
}
