import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'forgot_password.dart';

class LoginInfo {
  final bool success;
  // store session token variable later

  LoginInfo({required this.success});

  bool getSuccess() {
    return success;
  }
}

Future<LoginInfo> login(username, password) async {
  final response = await http.post(
      Uri.parse('http://localhost:8000/login/login_view/'),
      body: {'username': username, 'password': password});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return LoginInfo(success: true);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return LoginInfo(success: false);
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key}); // back button?

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  // we're not retrieving an initial state
  // late Future<LoginInfo> login_info;

  // @override
  // void initState() { // only used to cache login_info
  //   super.initState();
  //   login_info = ();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login Page',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 45, 221, 98)),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Login Page')),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Login',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: widget._usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onChanged: (value) {},
                        validator: (value) {
                          return value!.isEmpty ? 'Please enter email' : null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: widget._passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onChanged: (value) {},
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter password'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          LoginInfo loginInfo = await login(
                              widget._usernameController.text.trim(),
                              widget._passwordController.text.trim());
                          if (loginInfo.getSuccess()) {
                            Navigator.push(
                              // .then?
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyHomePage(title: 'Welcome!')),
                            );
                          } else {
                            throw Exception('Could not login');
                          }
                        },
                        // minWidth: 1000,
                        // color: Colors.teal,
                        // textColor: Colors.white,
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()),
                          );
                        },
                        child: Text('Forgot password?'), // left justify
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
