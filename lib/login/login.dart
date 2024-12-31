import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapy_chatbot/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    
    final activeColor = theme.colorScheme.onPrimaryContainer;
    final inactiveColor = theme.colorScheme.inversePrimary;
    final textFormDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: inactiveColor)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: activeColor),
      ),
      labelStyle: theme.textTheme.bodyLarge!.copyWith(
        color: activeColor,
      ),
      hintStyle: theme.textTheme.bodyLarge!.copyWith(
        color: inactiveColor,
      ),
    );
    
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
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
                  color: inactiveColor, // Replace with app icon.
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Login',
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: activeColor,
                ),
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
                          prefixIcon: Icon(Icons.email, color: activeColor),
                          labelText: 'Email',
                          hintText: 'user@example.com',
                        ),
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: activeColor,
                        ),
                        cursorColor: activeColor,
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
                          prefixIcon: Icon(Icons.password, color: activeColor),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: activeColor,
                        ),
                        cursorColor: activeColor,
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
                          appState.preferences.updateColorScheme(
                            const Color.fromARGB(255, 100, 149, 237),
                            0.0,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: activeColor,
                        ),
                        child: const Text('Forgot password?'),
                        onPressed: () {
                          appState.preferences.updateColorScheme(
                            const Color.fromARGB(255, 255, 255, 255),
                            0.0,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: activeColor,
                  side: BorderSide(color: activeColor),
                ),
                child: const Text('Create Account'),
                onPressed: () {
                  appState.preferences.updateColorScheme(
                    const Color.fromARGB(255, 0, 0, 0),
                    0.0,
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
