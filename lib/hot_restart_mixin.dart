import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/util/persistence.dart';

mixin HotRestartMixin on Widget {
  void hotRestartPrepare(BuildContext context) async {
    if (!kDebugMode) {
      return;
    }
    var database = Provider.of<AppDatabase>(context);
    await database.updateDebugData(runtimeType.toString());
    debugPrint('Stored $runtimeType for next restart.');
  }
}
