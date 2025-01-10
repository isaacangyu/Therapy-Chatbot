import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/login/validate_password.dart';
import '/util/navigation.dart';
import '/util/global.dart';
import '/util/network.dart';
import '/util/theme.dart';
import '/widgets/fields/name_large.dart';
import '/widgets/fields/email_large.dart';
import '/widgets/fields/password_large.dart';
import '/widgets/info_box.dart';
import '/widgets/loading.dart';
import '/widgets/scroll.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<ProjectTheme>();
    
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
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          NameFieldLarge(_nameController),
          const SizedBox(height: 10),
          EmailFieldLarge(_emailController),
          const SizedBox(height: 10),
          EmailConfirmationFieldLarge(_emailController),
          const SizedBox(height: 10),
          PasswordFieldLarge(_passwordController, validatePassword),
          const SizedBox(height: 10),
          PasswordConfirmationFieldLarge(_passwordController),
          const SizedBox(height: 20),
          ConfirmButton(
            formKey: _formKey,
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
        ],
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey, _nameController = nameController, _emailController = emailController, _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.check),
      label: const Text('Confirm'),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          pushRoute(
            context,
            const CreatingAccountPage()
          );
          var creationState = await _createAccount(
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
    final projectTheme = context.watch<ProjectTheme>();
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: projectTheme.primaryColor,
        body: Scroll(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoBox('Failed to create account:<br>$reason'),
                  const SizedBox(height: 20),
                  const ReturnToLoginButton()
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

class ReturnToLoginButton extends StatelessWidget {
  const ReturnToLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<ProjectTheme>();
    
    return OutlinedButton.icon(
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
    );
  }
}

class CreatingAccountPage extends StatelessWidget {
  const CreatingAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<ProjectTheme>();
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

Future<_CreationState> _createAccount(String name, String email, String password) {
  return httpPostSecure(
    API.createAccount,
    {
      'name': name,
      'email': email,
      'password': password,
    },
    (json) => _CreationState(json['success'], message: json['message']),
    () => _CreationState(false, message: 'Please check your internet connection.'),
  );
}

class _CreationState {
  _CreationState(this.success, {this.message});
  
  bool success;
  String? message;
}
