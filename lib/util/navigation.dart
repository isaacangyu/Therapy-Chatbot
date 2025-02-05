import 'package:flutter/material.dart';

void pushRoute(BuildContext context, Widget page) {
  Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => page),
  );
}

void replaceRoute(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
