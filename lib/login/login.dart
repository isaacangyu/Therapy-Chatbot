import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:therapy_chatbot/util/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = Provider.of<ProjectTheme>(context);
    
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 125,
                height: 125,
                child: Image(
                  image: AssetImage('app_assets/icon.png'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Login',
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: projectTheme.activeColor,
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
                          return (value != null && !EmailValidator.validate(value)) ? 'Invalid email address.' : null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: projectTheme.textFormDecoration.copyWith(
                          prefixIcon: Icon(Icons.password, color: projectTheme.activeColor),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: projectTheme.activeColor,
                        ),
                        cursorColor: projectTheme.activeColor,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          foregroundColor: projectTheme.activeColor,
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
                  foregroundColor: projectTheme.activeColor,
                  side: BorderSide(color: projectTheme.activeColor),
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
