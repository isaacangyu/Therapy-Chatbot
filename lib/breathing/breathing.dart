import 'package:flutter/material.dart';

class BreathingPage extends StatelessWidget {
  const BreathingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing'),
      ),
      body: Center(
          child: Container(
              width: 100.0,
              height: 100.0,
              decoration: const BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              child: const Text(
                  "Let's work on breathing. As the circle expands take a deep breath in and as the circle retracts let the air out. This can help with calming down."))),
    );
  }
}
