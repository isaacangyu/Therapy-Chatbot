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
  // final _blobController = BlobController();
  double _scale = 1.0;

  late final Blob _blobWidget;

  @override
  void initState() {
    super.initState();

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
              MaterialButton(
                child: const Text('Press to change SVG.'),
                onPressed: () {
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
