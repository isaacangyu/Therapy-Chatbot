import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/initialization/splash.dart';
import '/initialization/notice.dart';
import '/login/login.dart';
import '/util/global.dart';
import '/util/persistence.dart';
import '/util/theme.dart';
import '/app_state.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(database)),
        ChangeNotifierProvider(create: (_) => ProjectTheme()),
      ],
      child: Consumer2<AppState, ProjectTheme>(
        builder: (context, appState, projectTheme, child) {
          return FutureBuilder(
            future: appState.initializationComplete,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  title: Global.appTitle,
                  home: SplashScreen(),
                );
              }
              
              if (!snapshot.data!.success) {
                return MaterialApp(
                  title: Global.appTitle,
                  home: NoticeScreen(snapshot.data!.message!),
                );
              }
              
              var themeData = calculateThemeData(appState.preferences.colorScheme);
              projectTheme.set(themeData);
              appState.projectTheme = projectTheme;
              
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
