import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '/app_state.dart';
import '/login/validate_password.dart';
import '/util/navigation.dart';
import '/util/theme.dart';
import '/util/global.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<AppState>().projectTheme;
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: RegistrationForm(projectTheme: projectTheme, theme: theme),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({
    super.key,
    required this.projectTheme,
    required this.theme,
  });

  final ProjectTheme projectTheme;
  final ThemeData theme;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var passwordVisible = false;
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: widget.projectTheme.textFormDecoration.copyWith(
              prefixIcon: Icon(Icons.email, color: widget.projectTheme.activeColor),
              labelText: 'Email',
              hintText: 'user@example.com',
            ),
            style: widget.theme.textTheme.bodyLarge!.copyWith(
              color: widget.projectTheme.activeColor,
            ),
            cursorColor: widget.projectTheme.activeColor,
            autovalidateMode: AutovalidateMode.onUnfocus,
            validator: (value) {
              if (kDebugMode) {
                return null;
              }
              return (value != null && !EmailValidator.validate(value)) ? 'Invalid email address.' : null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: widget.projectTheme.textFormDecoration.copyWith(
              prefixIcon: Icon(Icons.email, color: widget.projectTheme.activeColor),
              labelText: 'Confirm Email',
            ),
            style: widget.theme.textTheme.bodyLarge!.copyWith(
              color: widget.projectTheme.activeColor,
            ),
            cursorColor: widget.projectTheme.activeColor,
            autovalidateMode: AutovalidateMode.onUnfocus,
            validator: (value) {
              return (value != emailController.text) ? 'Emails do not match.' : null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: !passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
            decoration: widget.projectTheme.textFormDecoration.copyWith(
              prefixIcon: Icon(Icons.password, color: widget.projectTheme.activeColor),
              labelText: 'Password',
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: widget.projectTheme.activeColor,
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            ),
            style: widget.theme.textTheme.bodyLarge!.copyWith(
              color: widget.projectTheme.activeColor,
            ),
            cursorColor: widget.projectTheme.activeColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (kDebugMode) {
                return null;
              }
              return value != null ? validatePassword(value) : null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: !passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
            decoration: widget.projectTheme.textFormDecoration.copyWith(
              prefixIcon: Icon(Icons.password, color: widget.projectTheme.activeColor),
              labelText: 'Confirm Password',
            ),
            style: widget.theme.textTheme.bodyLarge!.copyWith(
              color: widget.projectTheme.activeColor,
            ),
            cursorColor: widget.projectTheme.activeColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value != passwordController.text ? 'Passwords do not match' : null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Confirm'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                pushRoute(
                  context,
                  CreatingAccountPage(widget: widget)
                );
                var creationState = await createAccount(emailController.text, passwordController.text);
                if (context.mounted) {
                  if (creationState.success) {
                    pushRoute(
                      context,
                      const Placeholder()
                    );
                  } else {
                    pushRoute(
                      context,
                      RegistrationFailedPage(
                        widget: widget,
                        reason: creationState.message ?? '???'
                      )
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class RegistrationFailedPage extends StatelessWidget {
  const RegistrationFailedPage({
    super.key,
    required this.widget,
    required this.reason,
  });

  final RegistrationForm widget;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: widget.projectTheme.primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Html(data: 'Failed to create account:<br>$reason'),
              TextButton.icon(
                icon: Icon(Icons.arrow_back, color: widget.projectTheme.activeColor),
                label: const Text('Return to login.'),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst
                  );
                },
              )
            ],
          )
        ),
      ),
    );
  }
}

class CreatingAccountPage extends StatelessWidget {
  const CreatingAccountPage({
    super.key,
    required this.widget,
  });

  final RegistrationForm widget;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Global.loadingScreen(
        widget.projectTheme.primaryColor,
        widget.projectTheme.activeColor,
        child: const Text('Creating account...'),
      )
    );
  }
}

Future<CreationState> createAccount(String email, String password) async {  
  try {
    var response = await http.post(
      Uri.parse('${Global.baseURL}/create_account'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      return CreationState(json['success'], message: json['message']);
    }
    debugPrint('HTTP response code: ${response.statusCode}');
  } catch (e) {
    debugPrint('Request exception: $e');
  }
  return CreationState(false, message: 'Please check your internet connection.');
}

class CreationState {
  CreationState(this.success, {this.message});
  
  bool success;
  String? message;
}
