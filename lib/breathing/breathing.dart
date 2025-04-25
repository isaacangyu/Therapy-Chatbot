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

  double _speed = 0.5; // between 0 and 1
  bool _expanding = true;
  
  final String breatheInText = "Breathe in";
  final String breatheOutText = "Breathe out";
  // final String breathingText =
  //       "Let's work on breathing. As the circle expands, take a deep breath in. As the circle shrinks, let the breath out. This can help with calming down.";

  void _switchExpanding() {
    setState(() {
      _expanding = !_expanding;
    });
  }

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
              _expanding ? Text(breatheInText) : Text(breatheOutText),
              const SizedBox(height: 50),
              BreathingAnimation(speed: _speed, switchExpanding: _switchExpanding),
              const SizedBox(height: 50),
              SliderTheme(
                data: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always
                ),
                child:
                  Slider(
                    value: _speed, 
                    onChanged: (value) {
                      setState(() {
                        _speed = value;
                      });
                    },
                    label: "Speed: ${_speed.toStringAsFixed(1)}",
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BreathingAnimation extends StatefulWidget {
  const BreathingAnimation({super.key, required double speed, required Function switchExpanding}) : _speed = speed, _switchExpanding = switchExpanding;
  
  final double _speed;
  final Function _switchExpanding;

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation> {
  double _scale = 1.5;
  late Timer _timer; // late means initialized later
  late int _speed;
  
  @override
  void initState() { // initializing state
    super.initState();
    
    _speed = newSpeed();
    _timer = newTimer();
  }

  int newSpeed() => (((1 - widget._speed) * 5.0 + 2.5) * 1000).toInt();
  
  @override
  void didUpdateWidget(covariant BreathingAnimation oldWidget) { // initializing new widget
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
        _scale = _scale == 0.5 ? 1.5 : 0.5;
        widget._switchExpanding();
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
      onEnd: () => {

      },
      scale: _scale,
      child: const BlobIsolated(), // don't pass external state variables
    );
  }
}

class BlobIsolated extends StatelessWidget {
  const BlobIsolated({ super.key });

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
