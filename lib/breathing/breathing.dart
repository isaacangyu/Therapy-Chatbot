import 'package:flutter/material.dart';

class BreathingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathing'),
      ),
      body: Center(
        child: Text('Let's work on breathing. As the circle expands take a deep breath in and as the circle retracts let the air out. This can help with calming down.'),
        child: Container(
            width: 100.0,
            height: 100.0, 
            decoration: BoxDecoration(
              color: Colors.yellow, 
              shape: BoxShape.circle,
      ),
    );
  }
}
