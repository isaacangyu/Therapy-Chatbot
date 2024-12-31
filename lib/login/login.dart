import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final activeColor = theme.colorScheme.onPrimaryContainer;
    final inactiveColor = theme.colorScheme.inversePrimary;
    final textFormDecoration = InputDecoration(
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
    
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 125,
                height: 125,
                child: Placeholder(
                  color: inactiveColor, // Replace with app icon.
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Login',
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: activeColor,
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormDecoration.copyWith(
                          prefixIcon: Icon(Icons.email, color: activeColor),
                          labelText: 'Email',
                          hintText: 'user@example.com',
                        ),
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: activeColor,
                        ),
                        cursorColor: activeColor,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        validator: (value) {
                          return (value != null && !EmailValidator.validate(value)) ? 'Invalid email address.' : null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: textFormDecoration.copyWith(
                          prefixIcon: Icon(Icons.password, color: activeColor),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: activeColor,
                        ),
                        cursorColor: activeColor,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          return value != null ? validatePassword(value) : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: activeColor,
                        ),
                        child: const Text('Forgot password?'),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: activeColor,
                  side: BorderSide(color: activeColor),
                ),
                child: const Text('Create Account'),
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String? validatePassword(String password) {
    var lengthTest = PasswordTest(RegExp(r'^.{8,}$'), 'Password must be at least 8 characters long.');
    var lowerCaseTest = PasswordTest(RegExp(r'[a-z]'), 'Password must contain at least one lowercase letter.');
    var upperCaseTest = PasswordTest(RegExp(r'[A-Z]'), 'Password must contain at least one uppercase letter.');
    var digitTest = PasswordTest(RegExp(r'[0-9]'), 'Password must contain at least one digit.');
    var specialCharacterTest = PasswordTest(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'), 'Password must contain at least one special character.');
    
    for (var test in [lengthTest, lowerCaseTest, upperCaseTest, digitTest, specialCharacterTest]) {
      if (!test.regexp.hasMatch(password)) {
        return test.message;
      }
    }
    return null;
  }
}

class PasswordTest {
  final RegExp regexp;
  final String message;
  
  PasswordTest(this.regexp, this.message);
}
