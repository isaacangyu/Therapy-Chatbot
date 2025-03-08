import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Test")),
      body: LlmChatView(
        provider: GeminiProvider(
          model: GenerativeModel(model: 'gemini-1.5-flash', apiKey: ''),
        ),
      ),
    );
  }
}
