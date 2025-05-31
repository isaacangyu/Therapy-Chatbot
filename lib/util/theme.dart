import 'package:flutter/material.dart';

class CustomAppTheme extends ChangeNotifier {
  late Color primaryColor;
  late Color activeColor;
  late Color inactiveColor;
  late InputDecoration textFormDecoration;

  void set(ThemeData themeData) {
    primaryColor = themeData.colorScheme.primaryContainer;
    activeColor = themeData.colorScheme.onPrimaryContainer;
    inactiveColor = themeData.colorScheme.inversePrimary;
    textFormDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: inactiveColor)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: activeColor),
      ),
      labelStyle: themeData.textTheme.bodyLarge!.copyWith(
        color: activeColor,
      ),
      hintStyle: themeData.textTheme.bodyLarge!.copyWith(
        color: inactiveColor,
      ),
    );
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

ThemeData calculateThemeData(ColorScheme colorScheme) {
  var themeData = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
  );
  return themeData.copyWith(
    textSelectionTheme: themeData.textSelectionTheme.copyWith(
      selectionColor: themeData.colorScheme.inversePrimary,
      selectionHandleColor: themeData.colorScheme.inversePrimary,
      cursorColor: themeData.colorScheme.onPrimaryContainer,
    ),
  );
}
