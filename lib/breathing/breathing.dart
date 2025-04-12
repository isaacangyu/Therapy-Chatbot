import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class BreathingPage extends StatelessWidget {
  const BreathingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing'),
      ),
      body: const Center( // only vertical?
        child: BreathingArea(),
      )
    );
  }
}

class BreathingArea extends StatefulWidget {
  const BreathingArea({super.key});
  
  @override
  State<BreathingArea> createState() => _BreathingAreaState();
}

class _BreathingAreaState extends State<BreathingArea> {
  final String assetName = 'app_assets/circle.riv';
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String breathingText =
        "Let's work on breathing. As the circle expands, take a deep breath in. As the circle shrinks, let the breath out. This can help with calming down.";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(breathingText),
        SizedBox(height: 20),
        // Row(
        //   children: [
            Text('Timer'),
            SizedBox(width: 20),
            // Expanded(child: 
            SizedBox(child: 
            NumberInputWithIncrementDecrement(controller: _timeController, 
                                              scaleWidth: 0.3,
                                              scaleHeight: 0.5,
                                              incDecBgColor: Colors.amber, 
                                              initialValue: 2,
                                              max: 10,
                                              onIncrement: (num newlyIncrementedValue) {
                                                print('Newly incremented value is $newlyIncrementedValue');
                                              },
                                              ),
          //   ),
          // ],
          // mainAxisAlignment: MainAxisAlignment.center,
        // ),
        width: 500,),
        // SizedBox(height: 100),
        Expanded(
          child: RiveAnimation.asset( // https://www.youtube.com/watch?v=nut38kjyUqs&ab_channel=Rive 
                  assetName,
                ),
        ),
      ]
    );
  }
}