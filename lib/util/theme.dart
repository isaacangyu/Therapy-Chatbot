import 'package:flutter/material.dart';

class ProjectTheme {
  late Color primaryColor;
  late Color activeColor;
  late Color inactiveColor;
  late InputDecoration textFormDecoration;

  ProjectTheme(ThemeData theme) {
    primaryColor = theme.colorScheme.primaryContainer;
    activeColor = theme.colorScheme.onPrimaryContainer;
    inactiveColor = theme.colorScheme.inversePrimary;
    textFormDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: inactiveColor)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: activeColor),
      ),
      labelStyle: theme.textTheme.bodyLarge!.copyWith(
        color: activeColor,
      ),
      hintStyle: theme.textTheme.bodyLarge!.copyWith(
        color: inactiveColor,
      ),
    );
  }
}
