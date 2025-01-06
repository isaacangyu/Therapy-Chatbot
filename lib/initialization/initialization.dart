import 'package:flutter/material.dart';

import '/util/global.dart';

class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Global.defaultSeedColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 125,
              height: 125,
              child: Image(
                image: AssetImage('app_assets/icon.png'),
              ),
            ),
            SizedBox(
              height: 100,
              child: Global.loadingScreen(
                Color(Global.defaultSeedColor),
                Colors.black
              )
            ),
          ],
        ),
      ),
    );
  }
}
