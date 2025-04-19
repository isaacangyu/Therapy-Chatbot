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
    final projectTheme = context.watch<ProjectTheme>();
    
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      decoration: projectTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.person, color: projectTheme.activeColor),
        labelText: 'Name',
      ),
      style: theme.textTheme.bodyLarge!.copyWith(
        color: projectTheme.activeColor,
      ),
      cursorColor: projectTheme.activeColor,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if (kDebugMode) {
          return null;
        }
        return (value == null || value.isEmpty) ? 'Please enter a name.' : null;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
