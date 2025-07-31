import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../connection/connection.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();

  // Toggle: false = photo article, true = video article
  bool isVideo = false;

  // Common fields
  final TextEditingController _titleController = TextEditingController();

  // Photo article fields
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  int? _selectedCategoryId;
  List<Map<String, dynamic>> categories = [];
  bool isLoadingCategories = true;

  // Video article fields
  final TextEditingController _videoDescriptionController = TextEditingController();
  final TextEditingController _videoThumbnailController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse("$baseUrl/api/categories");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data.map((c) => {"id": c["id"], "name": c["name"]}).toList();
          isLoadingCategories = false;
        });
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Uri uri;
    Map<String, dynamic> body;

    if (isVideo) {
      // Validate video fields
      if (_videoUrlController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video URL is required')),
        );
        return;
      }

      uri = Uri.parse('$baseUrl/api/videos');
      body = {
        'title': _titleController.text.trim(),
        'description': _videoDescriptionController.text.trim(),
        'thumbnail_url': _videoThumbnailController.text.trim(),
        'video_url': _videoUrlController.text.trim(),
      };
    } else {
      // Validate photo article fields
      if (_imageUrlController.text.isEmpty || _selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image URL and Category are required')),
        );
        return;
      }

      uri = Uri.parse('$baseUrl/api/articles/full');
      body = {
        'title': _titleController.text.trim(),
        'summary': _summaryController.text.trim(),
        'category_id': _selectedCategoryId,
        'content': _contentController.text.trim(),
        'author': _authorController.text.trim(),
        'image': _imageUrlController.text.trim(),
      };
    }

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isVideo ? 'Video article submitted successfully' : 'Photo article submitted successfully')),
        );
        _formKey.currentState?.reset();
        _clearAllFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("Submission error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during submission')),
      );
    }
  }

  void _clearAllFields() {
    _titleController.clear();
    _summaryController.clear();
    _contentController.clear();
    _authorController.clear();
    _imageUrlController.clear();
    _videoDescriptionController.clear();
    _videoThumbnailController.clear();
    _videoUrlController.clear();
    setState(() {
      _selectedCategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Article')),
      body: isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle radio buttons
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Photo Article'),
                      value: false,
                      groupValue: isVideo,
                      onChanged: (val) {
                        setState(() {
                          isVideo = val!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Video Article'),
                      value: true,
                      groupValue: isVideo,
                      onChanged: (val) {
                        setState(() {
                          isVideo = val!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title - common field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
              ),

              const SizedBox(height: 16),

              // Conditional fields
              if (!isVideo) ...[
                // PHOTO ARTICLE FORM
                TextFormField(
                  controller: _summaryController,
                  decoration: const InputDecoration(labelText: 'Summary'),
                  maxLines: 2,
                  validator: (value) => value == null || value.isEmpty ? 'Summary is required' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: _selectedCategoryId,
                  items: categories
                      .map((c) => DropdownMenuItem<int>(
                    value: c['id'],
                    child: Text(c['name']),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  validator: (val) => val == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'Paste the full image URL here',
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Image URL is required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty ? 'Content is required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) => value == null || value.isEmpty ? 'Author is required' : null,
                ),
              ] else ...[
                // VIDEO ARTICLE FORM
                TextFormField(
                  controller: _videoDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _videoThumbnailController,
                  decoration: const InputDecoration(
                    labelText: 'Thumbnail URL',
                    hintText: 'Paste the full thumbnail image URL here',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _videoUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Video URL',
                    hintText: 'Paste the full video URL here',
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Video URL is required' : null,
                ),
              ],
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Article'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
