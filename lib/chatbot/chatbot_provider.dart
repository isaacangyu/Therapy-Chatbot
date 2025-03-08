// Forked from: https://github.com/flutter/ai/blob/main/lib/src/providers/implementations/echo_provider.dart

// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class ChatbotProvider extends LlmProvider with ChangeNotifier {
  ChatbotProvider({Iterable<ChatMessage>? history})
    : _history = List<ChatMessage>.from(history ?? []);

  final List<ChatMessage> _history;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    if (prompt == 'FAILFAST') debugPrint('Failing fast!');

    await Future.delayed(const Duration(milliseconds: 1000));
    yield '# Echo\n';

    switch (prompt) {
      case 'CANCEL':
        debugPrint("Cancelled!");
        break;
      case 'FAIL':
        debugPrint('User requested failure!');
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    yield prompt;

    yield '\n\n# Attachments\n${attachments.map((a) => a.toString())}';
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);
    final response = generateStream(prompt, attachments: attachments);

    // Note: The below issue will be resolved in Dart 3.6.
    
    // don't write this code if you're targeting the web until this is fixed:
    // https://github.com/dart-lang/sdk/issues/47764
    // await for (final chunk in chunks) {
    //   llmMessage.append(chunk);
    //   yield chunk;
    // }
    yield* response.map((chunk) {
      llmMessage.append(chunk);
      return chunk;
    });

    notifyListeners();
  }

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }
}
