import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/util/theme.dart';

import '/app_state.dart';
import '/login/validate_password.dart';

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
            onPressed: () {
              if (formKey.currentState!.validate()) {
              }
            },
          ),
        ],
      ),
    );
  }
}