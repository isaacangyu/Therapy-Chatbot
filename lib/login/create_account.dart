import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/navigation.dart';
import '/legal/tos.dart';
import '/legal/privacy.dart';
import '/app_state.dart';
import '/login/validate_password.dart';
import '/util/navigation.dart';
import '/util/global.dart';
import '/util/network.dart';
import '/util/theme.dart';
import '/util/crypto.dart';
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
    final customTheme = context.watch<CustomAppTheme>();
    
    return Scaffold(
      backgroundColor: customTheme.primaryColor,
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
  // Should be accepted if the app does not require legal agreements.
  var acceptedLegal = !Global.showLegal;
  
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
          PasswordConfirmationFieldLarge(
            _passwordController,
            onFieldSubmitted: acceptedLegal ? (_) => _createAccountAction(
              context, _formKey, _nameController, _emailController, _passwordController
            ) : null,
          ),
          const SizedBox(height: 10),
          // Legal documents, if applicable.
          Global.showLegal ? Legal(acceptedLegal, (value) => setState(() {
            acceptedLegal = value ?? false;
          })) : const SizedBox.shrink(),
          const SizedBox(height: 20),
          ConfirmButton(
            formKey: _formKey,
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            enabled: acceptedLegal,
          ),
        ],
      ),
    );
  }
}

class Legal extends StatelessWidget {
  const Legal(this.accepted, this.callback, {super.key});

  final bool accepted;
  final void Function(bool?) callback;

  @override
  Widget build(BuildContext context) {
    
    return Row(
      children: [
        Checkbox(
          value: accepted,
          onChanged: callback,
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'I accept the ',
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => pushRoute(context, const TosPage()),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => pushRoute(context, const PrivacyPage()),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
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
    required this.enabled,
  }) : _formKey = formKey, _nameController = nameController, _emailController = emailController, _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.check),
      label: const Text('Confirm'),
      onPressed: enabled ? () => _createAccountAction(
        context, _formKey, _nameController, _emailController, _passwordController
      ) : null,
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
    final customTheme = context.watch<CustomAppTheme>();
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: customTheme.primaryColor,
        body: Scroll(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoBox('Failed to create account:<br>$reason'),
                  const SizedBox(height: 20),
                  const ReturnToAccountCreationButton()
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

class ReturnToAccountCreationButton extends StatelessWidget {
  const ReturnToAccountCreationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomAppTheme>();
    
    return OutlinedButton.icon(
      icon: Icon(Icons.arrow_back, color: customTheme.activeColor),
      style: OutlinedButton.styleFrom(
        foregroundColor: customTheme.activeColor,
        side: BorderSide(color: customTheme.activeColor),
      ),
      label: const Text('Return to Account Creation'),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}

class CreatingAccountPage extends StatelessWidget {
  const CreatingAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomAppTheme>();
    return PopScope(
      canPop: false,
      child: LoadingScreen(
        customTheme.primaryColor,
        customTheme.activeColor,
        child: const Text('Creating account...'),
      )
    );
  }
}

Future<void> _createAccountAction(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController nameController,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  if (!formKey.currentState!.validate()) {
    return;
  }
  pushRoute(
    context,
    const CreatingAccountPage()
  );
  // The KDF function used during account creation is computationally expensive.
  // It seems to momentarily block the UI, despite be async.
  // This delay is placed intentionally to give the loading screen
  // a chance to display.
  if (!kDebugMode) {
    await Future.delayed(const Duration(seconds: 2));
  }
  
  if (context.mounted) {
    var appState = context.read<AppState>();
    var creationState = await _createAccount(
      nameController.text,
      emailController.text,
      passwordController.text,
      appState,
    );
    
    if (context.mounted) {
      if (creationState.success) {
        pushRoute(context, const Navigation());
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
}

/// Account Creation Procedure (Client Side)
/// 
/// 1. Generate a symmetric encryption key using the raw password and a salt.
///    This step uses a KDF.
/// 2. Store the encryption key in secure storage.
///    This is purposeful as to allow the user to use the app offline
///    without needing to log in every time.
/// 3. Generate a digest using the raw password.
///    This is to entirely avoid transmitting the raw password to the backend.
/// 4. The user's name, email, digest, and salt are sent for storage in the backend.
///    Note that the digest will be rehashed upon being received by the server.
/// 5. Store the session token from the response in secure storage.
/// 
Future<_CreationState> _createAccount(
  String name,
  String email,
  String password,
  AppState appState,
) async {
  var keyDetails = kdfKeyDerivation(initialKey: password);
  initClientSideEncrypter(keyDetails.key);
  
  var passwordDigest = sha256Digest(password);
  var creationState = await httpPostSecure(
    API.createAccount,
    {
      'name': name,
      'email': email,
      'password_digest': passwordDigest,
      'salt': keyDetails.salt
    },
    (json) => _CreationState(
      json['success'],
      message: json['message'],
      token: json['token']
    ),
    (status) => _CreationState(
      false, message: {
        -1: 'Please check your internet connection.',
        400: 'Invalid request.',
        422: 'Unprocessable request. Please check your field inputs.'
      }[status]
    ),
  );
  await appState.session.setEmail(email);
  await appState.session.setToken(creationState.token);
  await appState.session.setLoggedIn(creationState.success);
  
  return creationState;
}

class _CreationState {
  const _CreationState(this.success, {this.message, this.token});
  
  final bool success;
  final String? message;
  final String? token;
}
