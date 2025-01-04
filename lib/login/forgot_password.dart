import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/hot_restart_mixin.dart';
import 'package:therapy_chatbot/main.dart';

class ForgotPasswordPage extends StatelessWidget with HotRestartMixin {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    hotRestartPrepare(context);
    
    final projectTheme = context.watch<AppState>().projectTheme;
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
      ),
    );
  }
}
