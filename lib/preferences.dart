import 'package:flutter/material.dart';

import '/app_state.dart';
import '/util/persistence.dart';

class Preferences {
  late final AppState appState;
  late Preference data;
  
  late ColorScheme colorScheme;
  late int timerValue;
  late double speedValue;
  
  void updateColorScheme(Color seedColor, double contrastLevel) {
    colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      contrastLevel: contrastLevel,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    appState.notifyListeners();
  }
  
  void updateTimerValue(int newTimerValue) {
    timerValue = newTimerValue;
  }
  
  void updateSpeedValue(double newSpeedValue) {
    speedValue = newSpeedValue;
  }
}
