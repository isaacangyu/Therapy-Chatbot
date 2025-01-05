import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import '/app_state.dart';
import '/util/navigation.dart';
import '/login/forgot_password.dart';
import '/login/create_account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passwordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<AppState>().projectTheme;
    
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
                        obscureText: !passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: projectTheme.textFormDecoration.copyWith(
                          prefixIcon: Icon(Icons.password, color: projectTheme.activeColor),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: projectTheme.activeColor,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: projectTheme.activeColor,
                        ),
                        cursorColor: projectTheme.activeColor,
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
                          pushRoute(context, const ForgotPasswordPage());
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
                  pushRoute(context, const RegistrationPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
