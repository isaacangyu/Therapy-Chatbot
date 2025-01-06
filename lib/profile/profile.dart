import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar( // Profile picture.
                radius: 60.0,
                backgroundColor: Colors.teal,
                child: ClipOval(
                  child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Placeholder(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon( // Settings button.
                onPressed: () {
                  // Nothing for now.
                },
                icon: const Icon(Icons.settings),
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.teal),
                ),
                label: const Text('Settings'),
              ),
              const Spacer(),
              MaterialButton( // Signout button.
                onPressed: () {
                  // Nothing for now.
                },
                color: Colors.teal,
                textColor: Colors.white,
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
