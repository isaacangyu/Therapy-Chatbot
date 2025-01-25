import 'package:flutter/material.dart';
// import 'journal_screen.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 45, 221, 98)),
        useMaterial3: true,
      ),
      // home: JournalScreen(),
    );
  }
}