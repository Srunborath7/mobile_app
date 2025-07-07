import 'package:flutter/material.dart';
import '../page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostLoginSplash extends StatefulWidget {
  final String token;
  final String title;

  const PostLoginSplash({super.key, required this.token, required this.title});

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
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() => progress = i / 100);
    }

    // Get role_id and optionally user_id from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final roleId = prefs.getInt('role_id') ?? 0;
    final userId = prefs.getInt('user_id');

    // Navigate to MyHomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => MyHomePage(
              title: widget.title,
              token: widget.token,
              roleId: roleId,
              userId: userId,
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
              'Preparing your app...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              value: progress,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              "${(progress * 100).toInt()}%",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
