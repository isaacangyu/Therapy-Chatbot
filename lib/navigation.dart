import 'package:flutter/material.dart';

import '/widgets/adaptive_scaffold.dart';
import '/chatbot/chatbot.dart';
import '/breathing/breathing.dart';
// import '/journal/journal.dart';
import '/profile/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var _pageIndex = 0;

  final pages = <Widget>[
    const ChatbotPage(),
    const BreathingPage(), 
    // JournalApp(),
    const ProfilePage(),
  ];
  
  @override
  void initState() {
    var initialPage = pages[_pageIndex];
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
        // AdaptiveScaffoldDestination(
        //   title: 'Journal',
        //   icon: Icons.book,
        // ),
        AdaptiveScaffoldDestination(
          title: 'Profile',
          icon: Icons.person
        ),
      ],
      currentIndex: _pageIndex,
      onNavigationIndexChange: (value) {
        setState(() {
          var currentPage = pages[_pageIndex];
          if (currentPage is SwitchActions) {
            (currentPage as SwitchActions).onExitFocus(context);
          }
          
          _pageIndex = value;
          
          var nextPage = pages[_pageIndex];
          if (nextPage is SwitchActions) {
            (nextPage as SwitchActions).onFocus(context);
          }
        });
      },
      body: IndexedStack(
        index: _pageIndex,
        children: pages,
      ),
    );
  }
}

abstract class SwitchActions {
  void onFocus(BuildContext context);
  void onExitFocus(BuildContext context);
}
