import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/scroll.dart';
import '/util/theme.dart';
import '/widgets/loading.dart';
import '/widgets/info_box.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key, required this.legalType});
  
  final String legalType;

  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomAppTheme>();
    
    // Map `legalType` to the corresponding legal path doc.
    // Defaults to 'license' if `legalType` is invalid.
    final legalPath = {
      'tos': 'app_assets/legal/tos.html',
      'privacy': 'app_assets/legal/privacy.html',
      'license': 'app_assets/legal/license.html',
    }[legalType] ?? 'app_assets/legal/license.html';
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customTheme.primaryColor,
        foregroundColor: customTheme.activeColor,
      ),
      backgroundColor: customTheme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<String>(
          future: DefaultAssetBundle.of(context).loadString(legalPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen(
                customTheme.primaryColor, 
                customTheme.activeColor
              );
            } else if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const InfoBox('Error loading content.');
            } else {
              return Scroll(child: InfoBox(snapshot.data ?? ''));
            }
          },
        ),
      ),
    );
  }
}
