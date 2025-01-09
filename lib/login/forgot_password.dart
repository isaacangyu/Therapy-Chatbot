import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import '/util/global.dart';
import '/util/network.dart';
import '/widgets/loading.dart';
import '/widgets/scroll.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late Future<String> _forgotPasswordInfo;

  final _formKey = GlobalKey<FormState>();  
  final _emailController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _forgotPasswordInfo = fetchForgotPasswordInfo();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectTheme = context.watch<AppState>().projectTheme;
    
    return Scaffold(
      backgroundColor: projectTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _forgotPasswordInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen(projectTheme.primaryColor, projectTheme.activeColor);
          }
          return Scroll(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Html(
                        data: snapshot.data!,
                        style: {
                          'body': Style(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontSize: FontSize(theme.textTheme.bodyLarge!.fontSize!),
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Confirm'),
                            onPressed: () async {
                              // if (Global.offline(context)) {
                              //   return;
                              // }
                              if (_formKey.currentState!.validate()) {
                                var success = await requestPasswordReset(_emailController.text);
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
                          ),
                        ]
                      )
                    ),
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

Future<String> fetchForgotPasswordInfo() {
  return httpGetApi(
    API.forgotPasswordInfo,
    (json) => json['message'],
    () => 'There was a problem getting forgot password information. Please check your internet connection and use the form below.',
  );
}

Future<bool> requestPasswordReset(String email) {
  return httpPostSecure(
    API.resetPassword,
    {
      'email': email,
    },
    (_) => true,
    () => false,
  );
}
