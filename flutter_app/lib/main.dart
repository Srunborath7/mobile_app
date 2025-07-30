import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/login_page.dart';
import 'page/home_page.dart';

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
  String? fullName;
  int? roleId;
  int? userId;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final storedToken = prefs.getString('token');
    final storedFullName = prefs.getString('full_name');
    int? storedRoleId = prefs.getInt('role_id') ?? int.tryParse(prefs.getString('role_id') ?? '');
    int? storedUserId = prefs.getInt('user_id') ?? int.tryParse(prefs.getString('user_id') ?? '');

    if (storedToken != null && storedFullName != null && storedRoleId != null) {
      setState(() {
        token = storedToken;
        roleId = storedRoleId;
        userId = storedUserId;
        fullName = storedFullName;
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
      home: (token != null && fullName != null && roleId != null)
          ? MyHomePage(
        title: fullName!, // Pass full name here
        token: token!,
        roleId: roleId!,
        userId: userId,
        fullName: fullName!,
        email: '',
        address: '',
        phone: '',
        dob: '',
      )
          : const LoginPage(),
    );
  }
}
