import 'package:flutter/material.dart';
import 'package:therapy_chatbot/legal/legal.dart';

class TosPage extends StatelessWidget {
  const TosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(legalType: 'tos');
  }
}
