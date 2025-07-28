import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Center(child: Text('Post Page Content')),
    );
  }
}
