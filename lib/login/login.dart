import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    
    final textFormDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.inversePrimary)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.onPrimary),
      ),
      labelStyle: theme.primaryTextTheme.bodyLarge,
      hintStyle: theme.primaryTextTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.inversePrimary,
      ),
    );
    
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 125,
                height: 125,
                child: Placeholder(
                  color: theme.colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Login',
                style: theme.primaryTextTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormDecoration.copyWith(
                          prefixIcon: Icon(Icons.email, color: theme.primaryIconTheme.color),
                          labelText: 'Email',
                          hintText: 'user@example.com',
                        ),
                        style: theme.primaryTextTheme.bodyLarge,
                        cursorColor: theme.colorScheme.onPrimary,
                        validator: (value) {
                          return value!.isEmpty
                            ? 'Please enter email'
                            : null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: textFormDecoration.copyWith(
                          prefixIcon: Icon(Icons.password, color: theme.primaryIconTheme.color),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        style: theme.primaryTextTheme.bodyLarge,
                        cursorColor: theme.colorScheme.onPrimary,
                        validator: (value) {
                          return value!.isEmpty
                            ? 'Please enter email'
                            : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: theme.buttonTheme.colorScheme!.onPrimary,
                        ),
                        child: const Text('Forgot Password?'),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                  side: BorderSide(color: theme.colorScheme.onPrimary),
                ),
                child: const Text('Create Account'),
                onPressed: () {
                  appState.preferences.updateColorScheme(
                    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 62, 62, 62))
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
