import 'package:flutter/material.dart';

void pushRoute(BuildContext context, Widget page) {
  Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => page),
  );
}
