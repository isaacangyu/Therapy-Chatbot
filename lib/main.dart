import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/preferences.dart';
import '/login/login.dart';
import '/util/global.dart';
import '/util/persistence.dart';
import '/util/theme.dart';

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
                return MaterialApp(
                  title: Global.appTitle,
                  home: Global.loadingScreen(Colors.black, Colors.white),
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
              appState.projectTheme = ProjectTheme(themeData);
              
              debugPrint('Building main app widget tree.');
              
              return MaterialApp(
                title: Global.appTitle,
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
  late ProjectTheme projectTheme; // Updated in App.build.
  
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
