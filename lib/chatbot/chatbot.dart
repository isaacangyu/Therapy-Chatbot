import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '/chatbot/chatbot_provider.dart';
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
      body: appState.session.online ? LlmChatView(
        provider: ChatbotProvider(),
        welcomeMessage: 'Welcome!',
        style: LlmChatViewStyle(
          backgroundColor: customTheme.primaryColor,
          progressIndicatorColor: customTheme.activeColor,
          userMessageStyle: UserMessageStyle(
            textStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSecondaryFixed,
            ),
            decoration: (UserMessageStyle.defaultStyle().decoration as BoxDecoration).copyWith(
              color: theme.colorScheme.secondaryFixedDim,
            ),
          ),
          llmMessageStyle: LlmMessageStyle(
            icon: Icons.face_6,
            iconColor: theme.colorScheme.onSecondaryContainer,
            iconDecoration: (LlmMessageStyle.defaultStyle().iconDecoration as BoxDecoration).copyWith(
              color: theme.colorScheme.secondaryContainer,
            ),
            decoration: (LlmMessageStyle.defaultStyle().decoration as BoxDecoration).copyWith(
              color: theme.colorScheme.secondaryContainer,
              border: Border.all(color: customTheme.inactiveColor),
            ),
            // We may have to update this in the future if using additional markdown syntax.
            markdownStyle: MarkdownStyleSheet(
              p: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          chatInputStyle: ChatInputStyle(
            textStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.surface,
            ),
            hintText: 'Type a message...',
            backgroundColor: customTheme.primaryColor,
            decoration: (ChatInputStyle.defaultStyle().decoration as BoxDecoration).copyWith(
              color: theme.colorScheme.secondaryContainer,
              border: Border.all(color: customTheme.inactiveColor),
            ),
          ),
          addButtonStyle: ActionButtonStyle(
            iconDecoration: (ActionButtonStyle.defaultStyle(ActionButtonType.add).iconDecoration as BoxDecoration).copyWith(
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
          recordButtonStyle: ActionButtonStyle(
            iconDecoration: (ActionButtonStyle.defaultStyle(ActionButtonType.add).iconDecoration as BoxDecoration).copyWith(
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
        ),
      ) : const Center(child: Text('Chatbot not available offline ☹️.')),
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
      channel = status.channel;
      broadcast = status.broadcast;
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
    if (channel != null) {
      await websocketClose(channel!);
    }
    channel = null;
  }
}
