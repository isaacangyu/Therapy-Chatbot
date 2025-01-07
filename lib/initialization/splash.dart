import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '/util/global.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Global.defaultSeedColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 125,
              height: 125,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: const AssetImage('app_assets/icon.png'),
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
