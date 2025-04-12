import 'package:animated_svg/animated_svg.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '/util/theme.dart';
import '/widgets/scroll.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> {
  // final _blobController = BlobController();
  double _scale = 1.0;

  late final SvgController _svgController;
  late final Blob _blobWidget;

  @override
  void initState() {
    super.initState();
    _svgController = AnimatedSvgController();

    var projectTheme = context.read<ProjectTheme>();
    _blobWidget = Blob.animatedRandom(
      size: 200,
      edgesCount: 15,
      minGrowth: 8,
      styles: BlobStyles(
        // color: projectTheme.primaryColor,
        fillType: BlobFillType.fill,
        gradient: LinearGradient( // Note: Figure out how these gradient work later.
          colors: [projectTheme.inactiveColor, projectTheme.activeColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(const Rect.fromLTRB(0, 0, 300, 300)),
      ),
      loop: true,
      duration: const Duration(milliseconds: 1000),
      // controller: _blobController,
      // Note: You can *probably* put blobs inside of other blobs.
      child: const Center(
        child: Text(
          "This is a blob.",
          style: TextStyle(
            color: Colors.blueAccent,
            backgroundColor: Colors.white
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    // _blobController.dispose();
    _svgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ProjectTheme projectTheme = context.watch<ProjectTheme>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing'),
      ),
      body: Scroll(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Exhibit 1: The Blob'),
              // Docs: https://pub.dev/documentation/blobs/latest/
              AnimatedScale(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                scale: _scale,
                child: _blobWidget,
              ),
              MaterialButton(
                child: const Text('Press to change blob.'),
                onPressed: () {
                  // The blob controller can be used to explicitly 
                  // trigger the blob's animation if the blob is not 
                  // constructed with loop: true.
                  // _blobController.change();
                  
                  // Issue: This animation disrupts the blob's animation.
                  // unless the blob is isolated from the `_scale` state variable.
                  setState(() {
                    _scale = _scale == 1.0 ? 1.5 : 1.0;
                  });
                },
              ),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const Text('Exhibit 2: The SVG Blob'),
              // Docs: https://pub.dev/documentation/animated_svg/latest/
              // I thought that this library might have more interesting animations, 
              // but all it does is rotate while changing opacity between SVGs...
              AnimatedScale(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                scale: _scale,
                child: AnimatedSvg(
                  controller: _svgController,
                  duration: const Duration(milliseconds: 1000),
                  size: 200,
                  clockwise: false,
                  isActive: true,
                  children: [
                    SvgPicture.string('<svg version="1.1" viewBox="0.0 0.0 960.0 720.0" fill="none" stroke="none" stroke-linecap="square" stroke-miterlimit="10" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg"><clipPath id="p.0"><path d="m0 0l960.0 0l0 720.0l-960.0 0l0 -720.0z" clip-rule="nonzero"/></clipPath><g clip-path="url(#p.0)"><path fill="#000000" fill-opacity="0.0" d="m0 0l960.0 0l0 720.0l-960.0 0z" fill-rule="evenodd"/><defs><radialGradient id="p.1" gradientUnits="userSpaceOnUse" gradientTransform="matrix(17.455637786067076 0.0 0.0 17.455637786067076 0.0 0.0)" spreadMethod="pad" cx="26.966114680563855" cy="19.996166126390676" fx="26.966114680563855" fy="19.996166126390676" r="17.455636978149414"><stop offset="0.0" stop-color="#dcecd5"/><stop offset="1.0" stop-color="#92bc81"/></radialGradient></defs><path fill="url(#p.1)" d="m261.24844 258.12643c19.062561 -67.500015 128.43921 -122.5022 196.87665 -125.627304c68.43747 -3.1251068 185.62338 41.876633 213.74802 106.87663c28.124695 65.0 9.687256 233.43613 -45.0 283.12338c-54.687195 49.687195 -222.18591 59.062073 -283.12335 15.0c-60.93744 -44.062134 -101.56386 -211.87271 -82.50131 -279.3727z" fill-rule="evenodd"/></g></svg>'),
                    SvgPicture.string('<svg version="1.1" viewBox="0.0 0.0 960.0 720.0" fill="none" stroke="none" stroke-linecap="square" stroke-miterlimit="10" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg"><clipPath id="p.0"><path d="m0 0l960.0 0l0 720.0l-960.0 0l0 -720.0z" clip-rule="nonzero"/></clipPath><g clip-path="url(#p.0)"><path fill="#000000" fill-opacity="0.0" d="m0 0l960.0 0l0 720.0l-960.0 0z" fill-rule="evenodd"/><defs><radialGradient id="p.1" gradientUnits="userSpaceOnUse" gradientTransform="matrix(21.99482367969308 0.0 0.0 21.99482367969308 0.0 0.0)" spreadMethod="pad" cx="22.534359589022927" cy="16.880767797591716" fx="22.534359589022927" fy="16.880767797591716" r="21.994823455810547"><stop offset="0.0" stop-color="#dfeafb"/><stop offset="1.0" stop-color="#6e9ce7"/></radialGradient></defs><path fill="url(#p.1)" d="m133.83302 201.78326c31.807526 -94.33771 216.50655 -129.7594 333.97638 -138.79527c117.46985 -9.035873 319.87885 -9.034561 370.84253 84.58005c50.963684 93.61461 28.55426 396.86658 -65.06036 477.1076c-93.614624 80.24103 -390.0009 74.82062 -496.6273 4.338562c-106.626434 -70.482056 -174.93877 -332.89325 -143.13124 -427.23096z" fill-rule="evenodd"/></g></svg>')
                  ],
                ),
              ),
              MaterialButton(
                child: const Text('Press to change SVG.'),
                onPressed: () {
                  if (_svgController.isCompleted) {
                    _svgController.reverse();
                  } else {
                    _svgController.forward();
                  }
                  setState(() {
                    _scale = _scale == 1.0 ? 1.5 : 1.0;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
// const Text("Let's work on breathing. As the circle expands take a deep breath in, and as the [thing] contracts let the air out. This can help with calming down.")
