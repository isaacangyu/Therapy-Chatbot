import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/login/login.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Therapy Chatbot',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: appState.preferences.colorScheme,
            ),
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  final preferences = Preferences();
  
  AppState() {
    preferences.appState = this;
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class Preferences {
  AppState? appState;
  var colorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 100, 149, 237));
  
  void updateColorScheme(ColorScheme colorScheme) {
    this.colorScheme = colorScheme;
    appState?.notifyListeners();
  }
}
