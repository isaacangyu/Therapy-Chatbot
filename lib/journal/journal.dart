import 'package:flutter/material.dart';
// import '../login/journal_screen.dart'; // can you put it directly here without creating a new file?

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 45, 221, 98)),
        useMaterial3: true,
      ),
      home: JournalPage(), // changed from JournalScreen
    );
  }
}
