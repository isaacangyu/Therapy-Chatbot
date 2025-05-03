import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/global.dart';
import '/util/network.dart';
import '/util/theme.dart';
import '/widgets/fields/email_large.dart';
import '/widgets/info_box.dart';
import '/widgets/loading.dart';
import '/widgets/scroll.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late Future<String?> _forgotPasswordInfo;
  
  @override
  void initState() {
    super.initState();
    _forgotPasswordInfo = _fetchForgotPasswordInfo();
  }
  
  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomAppTheme>();
    
    return Scaffold(
      backgroundColor: customTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _forgotPasswordInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen(
              customTheme.primaryColor, 
              customTheme.activeColor
            );
          }
          return Scroll(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: snapshot.data != null ? [
                    InfoBox(snapshot.data!),
                    const SizedBox(height: 20),
                    const ForgotPasswordForm(),
                  ] : [
                    const InfoBox('There was a problem getting forgot password information. Please check your internet connection.'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();  
  final _emailController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailFieldLarge(_emailController),
          const SizedBox(height: 20),
          SubmitButton(formKey: _formKey, emailController: _emailController),
        ]
      )
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
  }) : _formKey = formKey, _emailController = emailController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.check),
      label: const Text('Confirm'),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          var success = await _requestPasswordReset(_emailController.text);
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset request sent.'),
              )
            );
          } else if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not send password reset request.'),
              )
            );
          }
        }
      }
    );
  }
}

Future<String?> _fetchForgotPasswordInfo() {
  return httpGetApi(
    API.forgotPasswordInfo,
    (json) => json['message'],
    () => null,
  );
}

Future<bool> _requestPasswordReset(String email) {
  return httpPostSecure(
    API.resetPassword,
    {
      'email': email,
    },
    (_) => true,
    () => false,
  );
}
