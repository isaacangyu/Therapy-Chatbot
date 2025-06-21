import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import '/util/network.dart';
import '/util/global.dart';
import '/util/theme.dart';
import '/util/crypto.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  WebSocketStatus? _socketStatus;
  final _messageLog = <Widget>[];
  
  void _sendMessage(String message) {
    websocketAddFrame(_socketStatus!.channel!, {
      "type": "message",
      "message": message,
    });
  }
  
  @override
  void initState() {
    super.initState();
    var appState = context.read<AppState>();
    if (appState.session.offline(context)) {
      return;
    }
    websocketConnect(API.wsChatbot, includeToken(
      appState.session.getEmail()!, 
      appState.session.getToken()!, 
      {
        'type': 'connect',
        'custom_response_key': responseKeyEncrypted,
      }
    )).then((status) {
      if (status.ok) {
        setState(() {
          _socketStatus = status;
        });
      } else if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Couldn't contact chatbot ☹️.")
          )
        );
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    if (_socketStatus != null && _socketStatus!.channel != null) {
      websocketClose(_socketStatus!.channel!);
    }
    super.dispose();
  }

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
      body: appState.session.online ? (_socketStatus == null 
        ? const Center(child: CircularProgressIndicator()) 
        : Stack(
          children: [
            SingleChildScrollView(
              child: StreamBuilder(
                stream: _socketStatus!.broadcast,
                // initialData: ,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    _messageLog.add(const BubbleSpecialThree(
                      text: 'SYSTEM: Sorry! Unknown error.',
                      isSender: false,
                    ));
                  } else if (snapshot.hasData) {
                    var response = snapshot.data;
                    
                    var chatbotResponse = jsonDecode(
                      verifyData(symmetricDecrypt(response, responseDecrypter))
                    ) as Map<String, dynamic>;
                    
                    if (!chatbotResponse.containsKey('status') || chatbotResponse['status'] is! int) {
                      _messageLog.add(const BubbleSpecialThree(
                        text: 'SYSTEM: Sorry! A problem occurred.',
                        isSender: false,
                      ));
                    } else {
                      try {
                        var responseCode = chatbotResponse['status'];
                        switch (responseCode) {
                          case 0:
                            var message = chatbotResponse['response'];
                            _messageLog.add(BubbleSpecialThree(
                              text: message["user"],
                              isSender: true,
                            ));
                            _messageLog.add(BubbleSpecialThree(
                              text: message["chatbot"],
                              isSender: false,
                            ));
                            break;
                          case 2:
                            _messageLog.add(const BubbleSpecialThree(
                              text: 'SYSTEM: ???', // No prompt received.
                              isSender: false,
                            ));
                            break;
                          case 3:
                            _messageLog.add(const BubbleSpecialThree(
                              text: 'SYSTEM: Sorry, something went wrong.', // Invalid type.
                              isSender: false,
                            ));
                            break;
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                        _messageLog.add(const BubbleSpecialThree(
                          text: 'SYSTEM: There was a problem while receiving messages.',
                          isSender: false,
                        ));
                      }
                    }
                  }
                  return Column(
                    children: _messageLog,
                  );
                },
              ),
            ),
            MessageBar(
              onSend: (message) => _sendMessage(message),
              // actions: [
              // ],
            ),
          ],
        )
      ) : const Center(child: Text('Chatbot not available offline ☹️.')),
    );
  }
}
