import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../page/home_page.dart';

class PostLoginSplash extends StatefulWidget {
  final String title;
  final String token;

  const PostLoginSplash({super.key, required this.title, required this.token});

  @override
  State<PostLoginSplash> createState() => _PostLoginSplashState();
}

class _PostLoginSplashState extends State<PostLoginSplash> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    simulateLoading();
  }

  Future<void> simulateLoading() async {
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        progress = i / 100;
      });
    }

    // Optional: ensure prefs are still saved
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', widget.token);
    await prefs.setString('welcome', widget.title);

    // Navigate to home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          title: widget.title,
          token: widget.token,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A31F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Logging in...",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              value: progress,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
            const SizedBox(height: 20),
            Text(
              "${(progress * 100).toInt()}%",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
