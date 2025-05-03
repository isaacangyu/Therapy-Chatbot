import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import '/util/crypto.dart';
import '/util/network.dart';
import '/util/navigation.dart';
import '/util/theme.dart';
import '/util/global.dart';
import '/login/forgot_password.dart';
import '/login/create_account.dart';
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
    final projectTheme = context.watch<CustomAppTheme>();
    
    return LoaderOverlay(
      child: Scaffold(
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
      ),
    );
  }
}

class GoToCreateAccountButton extends StatelessWidget {
  const GoToCreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<CustomAppTheme>();
    
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
          PasswordFieldLarge(
            _passwordController, 
            (value) => value.isEmpty ? 'Invalid password.' : null,
            onFieldSubmitted: (_) => _loginAction(
              context, _formKey, _emailController, _passwordController
            ),
          ),
          const SizedBox(height: 20),
          LoginButton(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController
          ),
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
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey, _emailController = emailController, _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Login'),
      onPressed: () => _loginAction(
        context, _formKey, _emailController, _passwordController
      ),
    );
  }
}

class GoToForgotPasswordPageButton extends StatelessWidget {
  const GoToForgotPasswordPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final projectTheme = context.watch<CustomAppTheme>();
    
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

Future<void> _loginAction(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController emailController,
  TextEditingController passwordController
) async {
  final theme = Theme.of(context);
  
  if (!formKey.currentState!.validate()) {
    return;
  }
  context.loaderOverlay.show();
  
  // The KDF function used during login is computationally expensive.
  // It seems to momentarily block the UI, despite be async.
  // This delay is placed intentionally to give the overlay
  // a chance to display.
  if (!kDebugMode) {
    await Future.delayed(const Duration(seconds: 2));
  }
  
  late _LoginState loginState;
  if (context.mounted) {
    var appState = context.read<AppState>();
    loginState = await _login(
      emailController.text,
      passwordController.text,
      appState,
    );
  }
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (loginState.success) {
      pushRoute(context, const PopScope(
        canPop: false,
        child: Placeholder()
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loginState.message ?? 'An unknown error occurred.',
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.onErrorContainer
            ),
          ),
          backgroundColor: theme.colorScheme.errorContainer,
        ),
      );
    }
  }
}

/// Login Procedure (Client Side)
/// 
/// 1. Generate a digest of the raw password.
/// 2. Send the email and digest to the server for validation.
///    The server will return the KDF salt and a session token.
/// 3. Generate the symmetric encryption key using the raw password and the salt via KDF.
///    Note: Testing the validity of the encryption key must be performed later.
/// 4. Store the session token in secure storage.
/// 
Future<_LoginState> _login(
  String email,
  String password,
  AppState appState
) async {
  var passwordDigest = sha256Digest(password);
  var loginState = await httpPostSecure(
    API.loginPassword,
    {
      'email': email,
      'password_digest': passwordDigest,
    },
    (json) => _LoginState(
      json['success'],
      message: json['message'],
      salt: json['salt'],
      token: json['token'],
    ),
    () => const _LoginState(
      false, message: 'Please check your internet connection.'
    ),
  );
  
  if (
    !loginState.success 
    || loginState.salt == null 
    || loginState.token == null
  ) {
    return _LoginState(loginState.success, message: loginState.message);
  }
  
  var keyDetails = kdfKeyDerivation(
    initialKey: password, salt: loginState.salt
  );
  initClientSideEncrypter(keyDetails.key);
  
  await appState.session.setToken(loginState.token);
  await appState.session.setLoggedIn(true);
  
  return loginState;
}

class _LoginState {
  const _LoginState(this.success, {this.message, this.salt, this.token});

  final bool success;
  final String? message;
  final String? salt;
  final String? token;
}
