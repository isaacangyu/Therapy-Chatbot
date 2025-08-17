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
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String message) {
    websocketAddFrame(_socketStatus!.channel!, {
      "type": "message",
      "message": message,
    });
  }

  void _scrollToBottomMaybe() {
    // If user is at or near the bottom, scroll to bottom after widget update.
    if (!_scrollController.hasClients) {
      return;
    }
    const threshold = 100.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxScroll - current < threshold) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
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
      // Disposed states should not be set in the case where a rebuild of the widget tree occurs.
      // Todo: This doesn't fully resolve the issue yet.
      if (status.ok && context.mounted) {
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
    _scrollController.dispose();
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
      backgroundColor: customTheme.primaryColor,
      body: appState.session.online ? (_socketStatus == null 
        ? Center(child: CircularProgressIndicator(color: customTheme.activeColor)) 
        : Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: StreamBuilder(
                stream: _socketStatus!.broadcast,
                // initialData: ,
                builder: (context, snapshot) {
                  bool messageAdded = false;
                  if (snapshot.hasError) {
                    messageAdded = true;
                    debugPrint(snapshot.error.toString());
                    _messageLog.add(BubbleSpecialThree(
                      text: 'SYSTEM: Sorry! Unknown error.',
                      isSender: false,
                      color: theme.colorScheme.secondaryFixedDim,
                      textStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ));
                  } else if (snapshot.hasData) {
                    messageAdded = true;
                    var response = snapshot.data;
                    
                    var chatbotResponse = jsonDecode(
                      verifyData(symmetricDecrypt(response, responseDecrypter))
                    ) as Map<String, dynamic>;
                    
                    if (!chatbotResponse.containsKey('status') || chatbotResponse['status'] is! int) {
                      _messageLog.add(BubbleSpecialThree(
                        text: 'SYSTEM: Sorry! A problem occurred.',
                        isSender: false,
                        color: theme.colorScheme.secondaryFixedDim,
                        textStyle: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.error,
                        ),
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
                              color: theme.colorScheme.secondaryFixedDim,
                              textStyle: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onSecondaryFixed,
                              ),
                            ));
                            _messageLog.add(BubbleSpecialThree(
                              text: message["chatbot"],
                              isSender: false,
                              color: theme.colorScheme.secondaryFixedDim,
                              textStyle: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onSecondaryFixed,
                              ),
                            ));
                            break;
                          case 2:
                            _messageLog.add(BubbleSpecialThree(
                              text: 'SYSTEM: ???', // No prompt received.
                              isSender: false,
                              color: theme.colorScheme.secondaryFixedDim,
                              textStyle: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ));
                            break;
                          case 3:
                            _messageLog.add(BubbleSpecialThree(
                              text: 'SYSTEM: Sorry, something went wrong.', // Invalid type.
                              isSender: false,
                              color: theme.colorScheme.secondaryFixedDim,
                              textStyle: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ));
                            break;
                          case _:
                            _messageLog.add(BubbleSpecialThree(
                              text: 'SYSTEM: Unknown response code: $responseCode', // Unknown.
                              isSender: false,
                              color: theme.colorScheme.secondaryFixedDim,
                              textStyle: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ));
                            break;
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                        _messageLog.add(BubbleSpecialThree(
                          text: 'SYSTEM: There was a problem while receiving messages.',
                          isSender: false,
                          color: theme.colorScheme.secondaryFixedDim,
                          textStyle: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ));
                      }
                    }
                  }
                  if (messageAdded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottomMaybe();
                    });
                  }
                  return Column(
                    children: [
                      Column(
                        children: _messageLog,
                      ),
                      const SizedBox(height: 100)
                    ],
                  );
                },
              ),
            ),
            MessageBar(
              onSend: (message) => _sendMessage(message),
              // actions: [
              // ],
              sendButtonColor: customTheme.activeColor,
              messageBarColor: theme.colorScheme.secondaryFixedDim,
              textFieldTextStyle: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSecondaryFixed,
              ),
            ),
          ],
        )
      ) : const Center(child: Text('Chatbot not available offline ☹️.')),
    );
  }
}
