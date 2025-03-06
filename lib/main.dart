import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/initialization/splash.dart';
import '/initialization/notice.dart';
import '/login/login.dart';
import '/util/global.dart';
import '/util/persistence.dart';
import '/util/theme.dart';
import '/app_state.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<AppDatabase>(
        create: (_) => AppDatabase(),
        dispose: (context, db) => db.close(),
      ),
      Provider<FlutterSecureStorage>(
        create: (_) => const FlutterSecureStorage()
      ),
    ],
    child: const App(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppBase();
}

class _AppBase extends State<App> {
  late final AppDatabase database;
  late final FlutterSecureStorage secureStorage;
  
  @override
  void initState() {
    super.initState();
    database = context.read<AppDatabase>();
    secureStorage = context.read<FlutterSecureStorage>();
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(database, secureStorage)),
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
              
              debugPrint('Building main app widget tree.');
              
              return MaterialApp(
                title: Global.appTitle,
                theme: themeData,
                home: appState.session.loggedIn 
                  ? const Placeholder() : const LoginPage(),
              );
            },
          );
        },
      ),
    );
  }
}
