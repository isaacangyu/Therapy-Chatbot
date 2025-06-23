import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/theme.dart';

class EmailFieldLarge extends StatelessWidget {
  const EmailFieldLarge(this._emailController, {super.key, this.onFieldSubmitted});

  final TextEditingController _emailController;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.watch<CustomAppTheme>();
    
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: customTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.email, color: customTheme.activeColor),
        labelText: 'Email',
        hintText: 'user@example.com',
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
        if (value == null || !EmailValidator.validate(value)) {
          return 'Invalid email address.';
        }
        if (value.length > 64) {
          return 'Email address is too long.';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

class EmailConfirmationFieldLarge extends StatelessWidget {
  const EmailConfirmationFieldLarge(this._emailController, {super.key, this.onFieldSubmitted});

  final TextEditingController _emailController;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.watch<CustomAppTheme>();
    
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: customTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.email, color: customTheme.activeColor),
        labelText: 'Confirm Email',
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
        return (value != _emailController.text) ? 'Emails do not match.' : null;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
