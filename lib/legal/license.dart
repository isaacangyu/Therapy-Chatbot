import 'package:flutter/material.dart';
import 'package:therapy_chatbot/legal/legal.dart';

class LicensePage extends StatelessWidget {
  const LicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(legalType: 'license');
  }
}
