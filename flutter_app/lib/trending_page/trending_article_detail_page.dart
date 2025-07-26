import 'package:flutter/material.dart';
import '../models/trending_article_detail.dart';
import '../services/trending_article_detail_service.dart';
import '../connection/connection.dart';

class TrendingArticleDetailPage extends StatelessWidget {
  final int articleId;
  const TrendingArticleDetailPage({super.key, required this.articleId});

  String _buildFullUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$baseUrl/$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Detail')),
      body: FutureBuilder<TrendingArticleDetail>(
        future: TrendingArticleDetailService.fetchDetail(articleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No detail found'));
          }

          final detail = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  _buildFullUrl(detail.fullImageUrl),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  detail.content,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

