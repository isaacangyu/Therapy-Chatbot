import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/theme.dart';

class NameFieldLarge extends StatelessWidget {
  const NameFieldLarge(this._nameController, {super.key, this.onFieldSubmitted});

  final TextEditingController _nameController;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.watch<CustomAppTheme>();
    
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      decoration: customTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.person, color: customTheme.activeColor),
        labelText: 'Name',
      ),
      style: theme.textTheme.bodyLarge!.copyWith(
        color: customTheme.activeColor,
      ),
      cursorColor: customTheme.activeColor,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if (kDebugMode) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'Please enter a name.';
        }
        if (value.length > 64) {
          return 'Name is too long.';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
