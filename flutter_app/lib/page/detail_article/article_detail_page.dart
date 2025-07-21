import 'package:flutter/material.dart';
import '../../models/article_detail.dart'; // use the correct model
import '../../connection/connection.dart'; // for baseUrl
import '../../services/article_detail_service.dart';

class ArticleDetailPage extends StatefulWidget {
  final int articleId;

  const ArticleDetailPage({Key? key, required this.articleId}) : super(key: key);

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  ArticleDetail? articleDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticle();
  }

  Future<void> fetchArticle() async {
    try {
      final fetchedArticle = await ArticleDetailService.fetchArticleDetailById(widget.articleId);

      setState(() {
        articleDetail = fetchedArticle;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _buildFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '$baseUrl/$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (articleDetail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Article not found')),
        body: const Center(child: Text('Could not load article')),
      );
    }

    final imageUrl = _buildFullImageUrl(articleDetail!.fullImage);

    return Scaffold(
      appBar: AppBar(title: Text('Article by ${articleDetail!.author}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Author: ${articleDetail!.author}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              articleDetail!.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
