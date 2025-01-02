import 'package:flutter/material.dart';
import 'package:therapy_chatbot/main.dart';

class Preferences {
  AppState? appState;
  ColorScheme? colorScheme;
  
  void updateColorScheme(Color seedColor, double contrastLevel) {
    colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      contrastLevel: contrastLevel,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    appState?.notifyListeners();
  }
}
