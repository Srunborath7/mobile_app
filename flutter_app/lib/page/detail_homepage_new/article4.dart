import 'package:flutter/material.dart';

class Article4Page extends StatelessWidget {
  const Article4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latest Sports Update')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1605296867304-46d5465a13f1',
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          const Text(
            'Latest Sports Update!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),

          const Text(
            'Our local team made headlines after a stunning comeback in last night\'s final match...',
            style: TextStyle(fontSize: 16),
          ),
          Image.network(
            'https://images.unsplash.com/photo-1605296867304-46d5465a13f1',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
