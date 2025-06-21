import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import '/util/network.dart';
import '/util/global.dart';
import '/util/theme.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketStatus? _socketStatus;
  
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
        _socketStatus = status;
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
      body: appState.session.online ? Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BubbleNormal(
                  text: 'bubble normal with tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  tail: true,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                BubbleNormal(
                  text: 'bubble normal with tail',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  sent: true,
                ),
                // DateChip(
                //   date: new DateTime(now.year, now.month, now.day - 2),
                // ),
                BubbleNormal(
                  text: 'bubble normal without tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  tail: false,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                BubbleNormal(
                  text: 'bubble normal without tail',
                  color: Color(0xFFE8E8EE),
                  tail: false,
                  sent: true,
                  seen: true,
                  delivered: true,
                ),
                BubbleSpecialOne(
                  text: 'bubble special one with tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                // DateChip(
                //   date: new DateTime(now.year, now.month, now.day - 1),
                // ),
                BubbleSpecialOne(
                  text: 'bubble special one with tail',
                  color: Color(0xFFE8E8EE),
                  seen: true,
                ),
                BubbleSpecialOne(
                  text: 'bubble special one without tail',
                  isSender: false,
                  tail: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                BubbleSpecialOne(
                  text: 'bubble special one without tail',
                  tail: false,
                  color: Color(0xFFE8E8EE),
                  sent: true,
                ),
                BubbleSpecialTwo(
                  text: 'bubble special tow with tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                // DateChip(
                //   date: now,
                // ),
                BubbleSpecialTwo(
                  text: 'bubble special tow with tail',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  sent: true,
                ),
                BubbleSpecialTwo(
                  text: 'bubble special tow without tail',
                  isSender: false,
                  tail: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                BubbleSpecialTwo(
                  text: 'bubble special tow without tail',
                  tail: false,
                  color: Color(0xFFE8E8EE),
                  delivered: true,
                ),
                BubbleSpecialThree(
                  text: 'bubble special three without tail',
                  color: Color(0xFF1B97F3),
                  tail: false,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
                BubbleSpecialThree(
                  text: 'bubble special three with tail',
                  color: Color(0xFF1B97F3),
                  tail: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
                BubbleSpecialThree(
                  text: "bubble special three without tail",
                  color: Color(0xFFE8E8EE),
                  tail: false,
                  isSender: false,
                ),
                BubbleSpecialThree(
                  text: "bubble special three with tail",
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  isSender: false,
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          MessageBar(
            onSend: (_) => print(_),
            actions: [
              // InkWell(
              //   child: Icon(
              //     Icons.add,
              //     color: Colors.black,
              //     size: 24,
              //   ),
              //   onTap: () {},
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 8, right: 8),
              //   child: InkWell(
              //     child: Icon(
              //       Icons.camera_alt,
              //       color: Colors.green,
              //       size: 24,
              //     ),
              //     onTap: () {},
              //   ),
              // ),
            ],
          ),
        ],
      ) : const Center(child: Text('Chatbot not available offline ☹️.')),
    );
  }

  void _sendMessage() {
    // if (_controller.text.isNotEmpty) {
    //   _channel.sink.add(_controller.text);
    // }
  }
}

            // StreamBuilder(
            //   stream: _channel.stream,
            //   builder: (context, snapshot) {
            //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
            //   },
            // ),

