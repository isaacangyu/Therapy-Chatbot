import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import '/util/theme.dart';
import '/widgets/fields/email_large.dart';
import '/util/global.dart';
import '/util/network.dart';
// import '/util/persistence.dart';
import '/login/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  @override
  void initState() {
    _emailController.text = context.read<AppState>().session.getEmail() ?? "";
    super.initState();
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.watch<CustomAppTheme>();

    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: theme.textTheme.titleLarge!.copyWith(color: customTheme.inactiveColor)
          ), 
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: customTheme.primaryColor,
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
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // ElevatedButton.icon( // Settings button.
                //   onPressed: () {
                //     // Nothing for now.
                //   },
                //   icon: const Icon(Icons.settings),
                //   style: const ButtonStyle(
                //     foregroundColor: WidgetStatePropertyAll(Colors.teal),
                //   ),
                //   label: const Text('Settings'),
                // ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EmailFieldLarge(_emailController),
                      const SizedBox(height: 20),
                      UpdateInfoButton(
                        formKey: _formKey,
                        emailController: _emailController,
                      ),
                    ]
                  )
                ),
                const Spacer(),
                MaterialButton( // Signout button.
                  onPressed: () async {
                    await _signout(context);
                  },
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateInfoButton extends StatelessWidget {
  const UpdateInfoButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
  }) : _formKey = formKey, _emailController = emailController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Update Info'),
      onPressed: () => _updateInfoAction(
        context, _formKey, _emailController
      ),
    );
  }
}

Future<void> _updateInfoAction(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController emailController,
) async {
  final theme = Theme.of(context);
  final customTheme = context.read<CustomAppTheme>();
  final appState = context.read<AppState>();
  
  if (!formKey.currentState!.validate() || appState.session.offline(context)) {
    return;
  }
  context.loaderOverlay.show();
  
  late bool updateSuccess;
  if (context.mounted) {
    var appState = context.read<AppState>();
    updateSuccess = await _updateInfo(
      emailController.text,
      appState,
    );
  }
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (updateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully updated information.',
            style: theme.textTheme.bodySmall!.copyWith(
              color: customTheme.activeColor
            ),
          ),
          backgroundColor: customTheme.inactiveColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An unknown error occurred.',
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

Future<bool> _updateInfo(
  String email,
  AppState appState
) async {
  var updateSuccess = await httpPostSecure(
    API.updateInfo,
    includeToken(
      appState.session.getEmail()!,
      appState.session.getToken()!,
      {
        'email': email,
      },
    ),
    (json) => json['success'],
    (status) => false
  );
    
  await appState.session.setEmail(email);
  
  return updateSuccess;
}

Future<void> _signout(BuildContext context) async {
  final appState = context.read<AppState>();
  // final database = context.read<AppDatabase>();
  
  await appState.session.setEmail(null);
  await appState.session.setToken(null);
  await appState.session.setEncryptionKey(null);
  
  // WIP
  // await database.dropAllTables();
  
  if (context.mounted) {
    // Crude way to get back to login for now.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
