import 'package:flutter/material.dart';

import '/widgets/adaptive_scaffold.dart';
import '/chatbot/chatbot.dart';
import '/breathing/breathing.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var pageIndex = 0;

  final pages = <Widget>[
    const ChatbotPage(),
    const BreathingPage(),
  ];
  
  @override
  void initState() {
    var initialPage = pages[pageIndex];
    if (initialPage is SwitchActions) {
      (initialPage as SwitchActions).onFocus(context);
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: const Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 100,
            height: 100,
            child: Image(
              image: AssetImage('app_assets/icon.png'),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      destinations: const [
        AdaptiveScaffoldDestination(
          title: 'Chatbot',
          icon: Icons.chat_bubble,
        ),
        AdaptiveScaffoldDestination(
          title: 'Breathing',
          icon: Icons.cloud,
        ),
      ],
      currentIndex: pageIndex,
      onNavigationIndexChange: (value) {
        setState(() {
          var currentPage = pages[pageIndex];
          if (currentPage is SwitchActions) {
            (currentPage as SwitchActions).onExitFocus(context);
          }
          
          pageIndex = value;
          
          var nextPage = pages[pageIndex];
          if (nextPage is SwitchActions) {
            (nextPage as SwitchActions).onFocus(context);
          }
        });
      },
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
    );
  }
}

abstract class SwitchActions {
  void onFocus(BuildContext context);
  void onExitFocus(BuildContext context);
}
