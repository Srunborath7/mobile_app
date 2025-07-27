import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'This is the Privacy Policy content.\n\n'
                'You can write or load the full privacy policy here.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
