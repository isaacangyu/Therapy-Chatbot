import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/main.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final projectTheme = context.watch<AppState>().projectTheme;
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            appState.preferences.updateColorScheme(Colors.black, 0.0);
          }, 
          child: Text('What')
        ),
      ),
    );
  }
}
