import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../connection/connection.dart'; // adjust path if needed

class TechnologyNewsScreen extends StatefulWidget {
  const TechnologyNewsScreen({super.key});

  @override
  State<TechnologyNewsScreen> createState() => _TechnologyNewsScreenState();
}

class _TechnologyNewsScreenState extends State<TechnologyNewsScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTechnologyArticles();
  }

  Future<void> fetchTechnologyArticles() async {
    try {
      final response =
      await http.get(Uri.parse('$baseUrl/api/categories/article/1'));
      if (response.statusCode == 200) {
        setState(() {
          articles = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load articles';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildArticleCard(dynamic article) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: article['image'] != null
            ? Image.network(
          article['image'],
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.article),
        title: Text(article['title'] ?? 'No Title'),
        subtitle: Text(article['summary'] ?? 'No Summary'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Technology News')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) =>
            _buildArticleCard(articles[index]),
      ),
    );
  }
}
