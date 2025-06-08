// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Forked from: https://github.com/flutter/ai/blob/main/lib/src/providers/implementations/echo_provider.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '/util/network.dart';
import '/util/crypto.dart';

WebSocketChannel? channel;
Stream<dynamic>? broadcast;

class ChatbotProvider extends LlmProvider with ChangeNotifier {
  ChatbotProvider({Iterable<ChatMessage>? history})
    : _history = List<ChatMessage>.from(history ?? []);

  final List<ChatMessage> _history;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    if (channel == null || channel?.sink == null || broadcast == null) {
      yield 'You are offline. Try restarting the app.';
      return;
    }
    
    websocketAddFrame(channel!, {
      "type": "message",
      "message": prompt,
    });
    await for (var response in broadcast!) {
      var chatbotResponse = jsonDecode(
        verifyData(symmetricDecrypt(response, responseDecrypter))
      ) as Map<String, dynamic>;
      if (!chatbotResponse.containsKey('status') || chatbotResponse['status'] is! int) {
        yield 'SYSTEM: Sorry! A problem occurred.';
        break;
      }
      yield {
        0: chatbotResponse['response'], // Success.
        2: 'SYSTEM: ???', // No prompt received.
        3: 'SYSTEM: Sorry, something went wrong.' // Invalid type.
      }[chatbotResponse['status']];
      break;
    }
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
