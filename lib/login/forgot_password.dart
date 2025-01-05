import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '/app_state.dart';
import '/util/global.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late Future<ForgotPasswordInfo> forgotPasswordInfo;
  
  @override
  void initState() {
    super.initState();
    forgotPasswordInfo = fetchForgotPasswordInfo();
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
        future: forgotPasswordInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Global.loadingScreen(projectTheme.primaryColor, projectTheme.activeColor);
          }
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Html(
                data: snapshot.data!.message,
                style: {
                  'body': Style(
                    color: projectTheme.activeColor,
                    fontSize: FontSize(theme.textTheme.bodyLarge!.fontSize!),
                  ),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ForgotPasswordInfo {
  final String message;
  
  const ForgotPasswordInfo({required this.message});
  
  factory ForgotPasswordInfo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'message': String message,
      } => 
        ForgotPasswordInfo(message: message),
      _ => throw const FormatException('Invalid JSON format.'),
    };
  }
}

Future<ForgotPasswordInfo> fetchForgotPasswordInfo() async {
  http.Response response;
  try {
    response = await http.get(Uri.parse(Global.forgotPasswordInfoUrl));
  } catch (e) {
    return ForgotPasswordInfo(message: 'Failed to fetch forgot password info. Exception: ${e.toString()}');
  }
  
  if (response.statusCode == 200) {
    return ForgotPasswordInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    return ForgotPasswordInfo(message: 'Failed to fetch forgot password info. Error code: ${response.statusCode}');
  }
}
