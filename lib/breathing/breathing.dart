import 'dart:async';

import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/app_state.dart';

import '/util/theme.dart';
import '/widgets/scroll.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> {
  bool _expanding = true;
  bool _playing = false;


  final String breatheInText = "Breathe in";
  final String breatheOutText = "Breathe out";
  final _timeController = TextEditingController();
  // final String breathingText =
  //       "Let's work on breathing. As the circle expands, take a deep breath in. As the circle shrinks, let the breath out. This can help with calming down.";

  void _switchExpanding() {
    setState(() {
      _expanding = !_expanding;
    });
    print('switched expanding to $_expanding');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<CustomAppTheme>();
    final appState = context.watch<AppState>();
    final size = MediaQuery.sizeOf(context);
    int time = appState.preferences.timerValue;
    double speed = appState.preferences.speedValue;
    print("loaded time $time, loaded speed $speed");

    void switchPlaying() {
      setState(() {
        _playing = !_playing;
      });
      print("switched playing to $_playing");
      final timeInt = int.parse(_timeController.text);
      appState.preferences.updateTimerValue(timeInt);
      appState.preferences.updateSpeedValue(speed);
      print("updated time with $timeInt and speed with $speed");
    }

    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      appBar: AppBar(
        // back button should automatically appear once home page goes to this page, if not set 'leading'
        title: const Text("Breathing"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimaryFixed,
      ),
      body: Scroll(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: _playing ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width / 3),
                      child: NumberInputWithIncrementDecrement(
                        controller: _timeController,
                        scaleWidth: 1,
                        scaleHeight: 0.7,
                        incDecBgColor: const Color.fromARGB(255, 131, 221, 246),
                        initialValue: time,
                        min: 1,
                        max: 10,
                        onIncrement: (num newlyIncrementedValue) {
                          print('Newly incremented timer value is $newlyIncrementedValue');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.height / 15),
                      child: ElevatedButton.icon(
                        onPressed: switchPlaying,
                        label: const Icon(Icons.play_arrow),
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), iconSize: size.height / 8),
                      ),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                          trackHeight: size.height / 15,
                          padding: EdgeInsets.symmetric(
                              vertical: size.height / 20, horizontal: size.width / 10),
                          showValueIndicator: ShowValueIndicator.always),
                      child: Slider(
                        value: speed,
                        onChanged: (value) {
                          setState(() {
                            speed = value;
                          });
                        },
                        label: "Speed: ${speed.toStringAsFixed(1)}",
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _playing ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: 
                InkWell(
                  onTap: switchPlaying,
                  child: Column(
                    children: [
                      _expanding
                          ? AnimatedOpacity(
                              opacity: _expanding ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Text(breatheInText))
                          : AnimatedOpacity(
                              opacity: _expanding ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 500),
                              child: Text(breatheOutText)),
                      SizedBox(height: size.height / 10),
                      _playing ? BreathingAnimation(
                          speed: speed, time: time, switchExpanding: _switchExpanding, switchPlaying: switchPlaying,) : const SizedBox.shrink()
                    ],
                  ),
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
  const BreathingAnimation(
      {super.key, required double speed, required int time, required Function switchExpanding, required Function switchPlaying})
      : _speed = speed,
        _time = time,
        _switchExpanding = switchExpanding,
        _switchPlaying = switchPlaying;

  final double _speed;
  final int _time;
  final Function _switchExpanding;
  final Function _switchPlaying;

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation> {
  double _scale = 1.5;
  late Timer _timer; // late means initialized later
  late int _speed;
  late int _time;

  @override
  void initState() {
    super.initState();
    // common milisecond unit to subtract
    _time = widget._time * 60 * 1000;
    _speed = newSpeed();
    _timer = newTimer();
  }

  int newSpeed() => (((1 - widget._speed) * 5.0 + 2.5) * 1000).toInt();

  @override
  void didUpdateWidget(covariant BreathingAnimation oldWidget) {
    // initializing new widget
    super.didUpdateWidget(oldWidget);

    if (oldWidget._speed != widget._speed) {
      _time = widget._time * 60 * 1000;
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
        print('Time left $_time Speed $_speed');
        _time -= _speed;
        if (_time <= 0) {
          widget._switchPlaying(); // navigate to original screen when done
          timer.cancel();
        }
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
      onEnd: () => {},
      scale: _scale,
      child: const BlobIsolated(), // don't pass external state variables
    );
  }
}

class BlobIsolated extends StatelessWidget {
  const BlobIsolated({super.key});

  @override
  Widget build(BuildContext context) {
    return Blob.animatedRandom(
      size: 200,
      edgesCount: 15,
      minGrowth: 9,
      styles: BlobStyles(
        fillType: BlobFillType.fill,
        gradient: const LinearGradient(
          // Note: Figure out how these gradient work later.
          colors: [
            Color.fromARGB(255, 29, 168, 33),
            Color.fromARGB(255, 19, 91, 21)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(const Rect.fromLTRB(0, 0, 300, 300)),
      ),
      loop: true,
      duration: const Duration(milliseconds: 1000),
    );
  }
}
