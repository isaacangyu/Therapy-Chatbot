import 'package:flutter/material.dart';

import '/app_state.dart';
import '/util/persistence.dart';

class Preferences {
  late final AppState appState;
  late ColorScheme colorScheme;
  late Preference data;
  
  void updateColorScheme(Color seedColor, double contrastLevel) {
    colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      contrastLevel: contrastLevel,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    appState.notifyListeners();
  }
}
