import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen(this.backgroundColor, this.indicatorColor, {super.key, this.child});
  
  final Color backgroundColor;
  final Color indicatorColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(indicatorColor),
            ),
            const SizedBox(height: 10),
            child ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
