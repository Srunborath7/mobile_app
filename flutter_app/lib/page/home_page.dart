import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final String token;

  const MyHomePage({super.key, required this.title, required this.token});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('welcome');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Profile photo circle avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                // Optional: Open profile page or settings
                // Navigator.push(...);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://i.pinimg.com/originals/94/9e/9a/949e9acf4df6075391f21248765bd8c3.jpg', // Replace with your user's profile photo URL
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Center(child: Text('Counter: $_counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
