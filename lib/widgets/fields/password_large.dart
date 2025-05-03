import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/theme.dart';

class PasswordFieldLarge extends StatefulWidget {
  const PasswordFieldLarge(this._passwordController, this._validator, {super.key, this.onFieldSubmitted});

  final TextEditingController _passwordController;
  final String? Function(String) _validator;
  final void Function(String)? onFieldSubmitted;

  @override
  State<PasswordFieldLarge> createState() => _PasswordFieldLargeState();
}

class _PasswordFieldLargeState extends State<PasswordFieldLarge> {
  var _passwordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<CustomAppTheme>();
    
    return TextFormField(
      controller: widget._passwordController,
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: projectTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.password, color: projectTheme.activeColor),
        labelText: 'Password',
        hintText: 'Enter your password',
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: projectTheme.activeColor,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        )
      ),
      style: theme.textTheme.bodyLarge!.copyWith(
        color: projectTheme.activeColor,
      ),
      cursorColor: projectTheme.activeColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (kDebugMode) {
          return null;
        }
        if (value == null) {
          return 'Invalid password.';
        }
        if (value.length > 128) {
          return 'Password is too long.';
        }
        return widget._validator(value);
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}

class PasswordConfirmationFieldLarge extends StatefulWidget {
  const PasswordConfirmationFieldLarge(this._passwordController, {super.key, this.onFieldSubmitted});

  final TextEditingController _passwordController;
  final void Function(String)? onFieldSubmitted;

  @override
  State<PasswordConfirmationFieldLarge> createState() => _PasswordConfirmationFieldLargeState();
}

class _PasswordConfirmationFieldLargeState extends State<PasswordConfirmationFieldLarge> {
  var _passwordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<CustomAppTheme>();
    
    return TextFormField(
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: projectTheme.textFormDecoration.copyWith(
        prefixIcon: Icon(Icons.password, color: projectTheme.activeColor),
        labelText: 'Confirm Password',
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: projectTheme.activeColor,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      style: theme.textTheme.bodyLarge!.copyWith(
        color: projectTheme.activeColor,
      ),
      cursorColor: projectTheme.activeColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (kDebugMode) {
          return null;
        }
        return value != widget._passwordController.text ? 'Passwords do not match' : null;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
