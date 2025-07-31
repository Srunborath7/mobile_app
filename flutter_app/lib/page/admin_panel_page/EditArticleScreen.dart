// update_article_page.dart
import 'package:flutter/material.dart';
import '../../models/article.dart';
import '../../services/article_service.dart';

class UpdateArticlePage extends StatefulWidget {
  final Article article;
  const UpdateArticlePage({super.key, required this.article});

  @override
  State<UpdateArticlePage> createState() => _UpdateArticlePageState();
}

class _UpdateArticlePageState extends State<UpdateArticlePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _summaryController;
  late TextEditingController _contentController;
  late TextEditingController _authorController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _summaryController = TextEditingController(text: widget.article.summary);
    _contentController = TextEditingController(text: widget.article.content ?? '');
    _authorController = TextEditingController(text: widget.article.author ?? '');
    _imageUrlController = TextEditingController(text: widget.article.imageUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedArticle = Article(
        id: widget.article.id,
        title: _titleController.text,
        summary: _summaryController.text,
        content: _contentController.text,
        author: _authorController.text,
        imageUrl: _imageUrlController.text,
      );
      await ArticleService.updateArticle(updatedArticle);

      if (mounted) {
        Navigator.pop(context, true); // return true if update success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Article')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Title required' : null,
              ),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(labelText: 'Summary'),
                validator: (value) => value!.isEmpty ? 'Summary required' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
