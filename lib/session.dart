import '/app_state.dart';
import '/util/persistence.dart';

class Session {
  late final AppState appState;
  late bool online;
  late SessionData data;
  
  void setOnline(bool state) {
    online = state;
    appState.notifyListeners();
  }
}
