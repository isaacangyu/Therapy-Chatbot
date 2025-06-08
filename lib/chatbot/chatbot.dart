import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/theme.dart';
import '/util/network.dart';
import '/util/global.dart';
import '/navigation.dart';
import '/app_state.dart';

class ChatbotPage extends StatelessWidget implements SwitchActions {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.watch<CustomAppTheme>();
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chatbot",
          style: theme.textTheme.titleLarge!.copyWith(color: customTheme.inactiveColor)
        ), 
        backgroundColor: theme.colorScheme.primary
      ),
      body: appState.session.online ? const Placeholder() : const Center(child: Text('Chatbot not available offline ☹️.')),
    );
  }
  
  @override
  void onFocus(BuildContext context) async {
    var appState = context.read<AppState>();
    if (appState.session.offline(context)) {
      return;
    }
    var status = await websocketConnect(API.wsChatbot, includeToken(
      appState.session.getEmail()!, 
      appState.session.getToken()!, 
      {
        'type': 'connect',
        'custom_response_key': responseKeyEncrypted,
      }
    ));
    if (status.ok) {
      // channel = status.channel;
      // broadcast = status.broadcast;
    } else {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't contact chatbot ☹️.")
        )
      );
    }
  }
  
  @override
  void onExitFocus(BuildContext context) async {
    // if (channel != null) {
    //   await websocketClose(channel!);
    // }
    // channel = null;
  }
}
