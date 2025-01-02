import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/preferences.dart';
import 'package:therapy_chatbot/util/persistence.dart';
import 'package:therapy_chatbot/login/login.dart';

const appTitle = kDebugMode ? 'DEBUG | Therapy Chatbot' : 'Therapy Chatbot';

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
          return FutureBuilder(
            future: appState.preferencesLoaded,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  title: appTitle,
                  home: Scaffold(
                    backgroundColor: Colors.black,
                    body: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ),
                );
              }
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
              debugPrint('Building main app widget tree.');
              return MaterialApp(
                title: appTitle,
                theme: themeData,
                home: const LoginPage(),
              );
            },
          );
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  final preferences = Preferences();
  late final Future<void> preferencesLoaded;
  
  AppState(AppDatabase database) {
    preferencesLoaded = database.getUserPreferences().then((userPreferences) {
      preferences.appState = this;
      preferences.colorScheme = ColorScheme.fromSeed(
        seedColor: Color(userPreferences.seedColor),
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      );
      debugPrint('''
Default preferences from app database:
Color Scheme: ${preferences.colorScheme}
''');
    });
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
