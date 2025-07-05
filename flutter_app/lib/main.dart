import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/login_page.dart';
import 'page/home_page.dart';  // This is your MyHomePage with bottom tabs

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  String? welcome;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final storedWelcome = prefs.getString('welcome');

    if (storedToken != null && storedWelcome != null) {
      setState(() {
        token = storedToken;
        welcome = storedWelcome;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: (token != null && welcome != null)
          ? MyHomePage(title: welcome!, token: token!)  // Show your main home page after login
          : const LoginPage(),                           // Show login if no token
    );
  }
}
