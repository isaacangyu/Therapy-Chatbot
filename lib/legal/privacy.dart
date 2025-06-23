import 'package:flutter/material.dart';
import 'package:therapy_chatbot/legal/legal.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(legalType: 'privacy');
  }
}
