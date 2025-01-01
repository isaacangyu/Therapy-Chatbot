import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/util/persistence.dart';
import 'package:therapy_chatbot/login/login.dart';

void main() {
  runApp(Provider<AppDatabase>(
    create: (context) => AppDatabase(),
    child: const App(),
    dispose: (context, db) => db.close(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var database = Provider.of<AppDatabase>(context);
    return ChangeNotifierProvider(
      create: (context) => AppState(database),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          var themeData = ThemeData(
            useMaterial3: true,
            colorScheme: appState.preferences.colorScheme,
          );
          themeData = themeData.copyWith(
            textSelectionTheme: themeData.textSelectionTheme.copyWith(
              selectionColor: themeData.colorScheme.inversePrimary,
              selectionHandleColor: themeData.colorScheme.inversePrimary,
              cursorColor: themeData.colorScheme.onPrimaryContainer,
            ),
          );
          return MaterialApp(
            title: 'Therapy Chatbot',
            theme: themeData,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  final preferences = Preferences();
  
  AppState(AppDatabase database) {    
    database.getUserPreferences().then((userPreferences) {
      preferences.appState = this;
      preferences.colorScheme = ColorScheme.fromSeed(
        seedColor: Color(userPreferences.seedColor),
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      );
    });
    
    if (kDebugMode) {
      print('''
Default preferences from app database:
Color Scheme: ${preferences.colorScheme}
''');
    }
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

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
