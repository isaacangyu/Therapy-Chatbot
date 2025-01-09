import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import '/login/validate_password.dart';
import '/util/navigation.dart';
import '/util/global.dart';
import '/util/network.dart';
import '/widgets/loading.dart';
import '/widgets/scroll.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<AppState>().projectTheme;
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Scroll(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const RegistrationForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});
  
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _passwordVisible = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final projectTheme = appState.projectTheme;
    final online = appState.session.online;
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
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
          ),
          const SizedBox(height: 10),
          TextFormField(
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
          ),
          const SizedBox(height: 10),
          TextFormField(
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
              return (value != _emailController.text) ? 'Emails do not match.' : null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
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
              return value == null ? 'Invalid password.' : validatePassword(value);
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: !_passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
            decoration: projectTheme.textFormDecoration.copyWith(
              prefixIcon: Icon(Icons.password, color: projectTheme.activeColor),
              labelText: 'Confirm Password',
            ),
            style: theme.textTheme.bodyLarge!.copyWith(
              color: projectTheme.activeColor,
            ),
            cursorColor: projectTheme.activeColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value != _passwordController.text ? 'Passwords do not match' : null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Confirm'),
            onPressed: () async {
              if (Global.offline(context, online)) {
                return;
              }
              if (_formKey.currentState!.validate()) {
                pushRoute(
                  context,
                  const CreatingAccountPage()
                );
                var creationState = await createAccount(
                  _nameController.text,
                  _emailController.text,
                  _passwordController.text
                );
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
    required this.reason,
  });

  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<AppState>().projectTheme;
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: projectTheme.primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Html(
                  style: {
                    'body': Style(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontSize: FontSize(theme.textTheme.bodyLarge!.fontSize!),
                    ),
                  },
                  data: 'Failed to create account:<br>$reason',
                )
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                icon: Icon(Icons.arrow_back, color: projectTheme.activeColor),
                style: OutlinedButton.styleFrom(
                  foregroundColor: projectTheme.activeColor,
                  side: BorderSide(color: projectTheme.activeColor),
                ),
                label: const Text('Return to Login'),
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
  const CreatingAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<AppState>().projectTheme;
    return PopScope(
      canPop: false,
      child: LoadingScreen(
        projectTheme.primaryColor,
        projectTheme.activeColor,
        child: const Text('Creating account...'),
      )
    );
  }
}

Future<CreationState> createAccount(String name, String email, String password) {
  return httpPostSecure(
    API.createAccount,
    {
      'name': name,
      'email': email,
      'password': password,
    },
    (json) => CreationState(json['success'], message: json['message']),
    () => CreationState(false, message: 'Please check your internet connection.'),
  );
}

class CreationState {
  CreationState(this.success, {this.message});
  
  bool success;
  String? message;
}
