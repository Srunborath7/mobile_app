import 'package:flutter/material.dart';
import '../models/trending_article.dart';
import '../services/trending_article_service.dart';
import '../connection/connection.dart';
import './trending_article_detail_page.dart'; // adjust path


class TrendingArticlePage extends StatefulWidget {
  const TrendingArticlePage({super.key});

  @override
  State<TrendingArticlePage> createState() => _TrendingArticlePageState();
}

class _TrendingArticlePageState extends State<TrendingArticlePage> {
  late Future<List<TrendingArticle>> _futureTrending;

  @override
  void initState() {
    super.initState();
    _futureTrending = TrendingArticleService.fetchTrendingArticles();
  }

  String _buildFullUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$baseUrl/$path';
  }

  Widget _trendingBox(TrendingArticle article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TrendingArticleDetailPage(articleId: article.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                _buildFullUrl(article.imageUrl),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(article.summary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Articles')),
      body: FutureBuilder<List<TrendingArticle>>(
        future: _futureTrending,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No trending articles found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: snapshot.data!
                  .map((article) => _trendingBox(article))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
