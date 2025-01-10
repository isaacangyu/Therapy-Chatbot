import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/navigation.dart';
import '/util/theme.dart';
import '/util/global.dart';
import '/login/forgot_password.dart';
import '/login/create_account.dart';
import '/login/validate_password.dart';
import '/widgets/fields/email_large.dart';
import '/widgets/fields/password_large.dart';
import '/widgets/scroll.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<ProjectTheme>();
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      body: Scroll(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(),
                const SizedBox(height: 20),
                Text(
                  Global.appTitle,
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color: projectTheme.activeColor,
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const LoginForm(),
                ),
                const SizedBox(height: 20),
                const GoToCreateAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoToCreateAccountButton extends StatelessWidget {
  const GoToCreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<ProjectTheme>();
    
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: projectTheme.activeColor,
        side: BorderSide(color: projectTheme.activeColor),
      ),
      child: const Text('Create Account'),
      onPressed: () {
        pushRoute(context, const RegistrationPage());
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
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
          EmailFieldLarge(_emailController),
          const SizedBox(height: 10),
          PasswordFieldLarge(_passwordController, validatePassword),
          const SizedBox(height: 20),
          LoginButton(formKey: _formKey),
          const SizedBox(height: 10),
          const GoToForgotPasswordPageButton(),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Login'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
        }
      },
    );
  }
}

class GoToForgotPasswordPageButton extends StatelessWidget {
  const GoToForgotPasswordPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<ProjectTheme>();
    
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: projectTheme.activeColor,
      ),
      child: const Text('Forgot password?'),
      onPressed: () {
        pushRoute(context, const ForgotPasswordPage());
      },
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 125,
      height: 125,
      child: Image(
        image: AssetImage('app_assets/icon.png'),
      ),
    );
  }
}
