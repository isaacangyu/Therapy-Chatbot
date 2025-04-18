import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blobs/blobs.dart';

import '/util/theme.dart';
import '/widgets/scroll.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> {

  double _speed = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<ProjectTheme>();
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      appBar: AppBar(
        title: const Text("Breathing"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimaryFixed,
      ),
      body: Scroll(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BreathingAnimation(speed: _speed),
              const SizedBox(height: 50),
              Text(
                "Breathing Speed: ${_speed.toStringAsFixed(1)}",
                style: theme.textTheme.labelLarge!.copyWith(
                  color: projectTheme.activeColor,
                ),
              ),
              Slider(value: _speed, onChanged: (value) {
                setState(() {
                  _speed = value;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class BreathingAnimation extends StatefulWidget {
  const BreathingAnimation({super.key, required double speed}) : _speed = speed;
  
  final double _speed;

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation> {
  double _scale = 1.0;
  late Timer _timer;
  late int _speed;
  
  @override
  void initState() {
    super.initState();
    
    _speed = newSpeed();
    _timer = newTimer();
  }

  int newSpeed() => (((1 - widget._speed) * 5.0 + 0.5) * 1000).toInt();
  
  @override
  void didUpdateWidget(covariant BreathingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget._speed != widget._speed) {
      _speed = newSpeed();
      _timer.cancel();
      _timer = newTimer();
    }
  }

  Timer newTimer() {
    return Timer.periodic(Duration(milliseconds: _speed), (timer) {
      setState(() {
        _scale = _scale == 1.0 ? 1.5 : 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: Duration(milliseconds: _speed),
      curve: Curves.easeInOut,
      scale: _scale,
      child: const BlobIsolated(),
    );
  }
}

class BlobIsolated extends StatelessWidget {
  const BlobIsolated({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Blob.animatedRandom(
      size: 200,
      edgesCount: 15,
      minGrowth: 9,
      styles: BlobStyles(
        fillType: BlobFillType.fill,
        gradient: const LinearGradient( // Note: Figure out how these gradient work later.
          colors: [Color.fromARGB(255, 29, 168, 33), Color.fromARGB(255, 19, 91, 21)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(const Rect.fromLTRB(0, 0, 300, 300)),
      ),
      loop: true,
      duration: const Duration(milliseconds: 1000),
    );
  }
}
