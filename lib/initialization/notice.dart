import 'package:flutter/material.dart';

import '/util/global.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen(this._message, {super.key});
  
  final String _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Global.defaultSeedColor),
      body: AlertDialog(
        title: const Text('Sorry!'),
        content: Text(_message),
      )
    );
  }
}
