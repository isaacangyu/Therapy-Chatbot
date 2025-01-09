import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/theme.dart';

class EmailFieldLarge extends StatelessWidget {
  const EmailFieldLarge(this._emailController, {super.key});

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<ProjectTheme>();
    
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: projectTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.email, color: projectTheme.activeColor),
        labelText: 'Email',
        hintText: 'user@example.com',
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
        return (value == null || !EmailValidator.validate(value)) ? 'Invalid email address.' : null;
      },
    );
  }
}

class EmailConfirmationFieldLarge extends StatelessWidget {
  const EmailConfirmationFieldLarge(this._emailController, {super.key});

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<ProjectTheme>();
    
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: projectTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.email, color: projectTheme.activeColor),
        labelText: 'Confirm Email',
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
        return (value != _emailController.text) ? 'Emails do not match.' : null;
      },
    );
  }
}
