import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'This is the Terms of Use content.\n\n'
                'You can write or load the full terms of use here.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
