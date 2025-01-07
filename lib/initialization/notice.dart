import 'package:flutter/material.dart';

import '/util/global.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen(this.message, {super.key});
  
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Global.defaultSeedColor),
      body: AlertDialog(
        title: const Text('Sorry!'),
        content: Text(message),
      )
    );
  }
}
