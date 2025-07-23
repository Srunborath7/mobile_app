import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart'; // <-- Add this import to support Article list
import '../models/article_detail.dart';
import '../connection/connection.dart';

class ArticleService {
  /// Fetch a single article by ID
  static Future<ArticleDetail> fetchArticleById(int id) async {
    final url = '$baseUrl/api/articles/$id';
    print('Fetching article by id from: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('Decoded JSON: $decoded');

      // Optional: If your backend wraps it like { "article": { ... } }
      if (decoded is Map && decoded.containsKey('article')) {
        return ArticleDetail.fromJson(decoded['article']);
      }

      return ArticleDetail.fromJson(decoded);
    } else {
      throw Exception('Failed to load article with id $id');
    }
  }

  /// ✅ Add this: Fetch all articles
  static Future<List<Article>> fetchArticles() async {
    final url = '$baseUrl/api/articles';
    print('Fetching all articles from: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // If backend returns { articles: [...] }
      if (decoded is Map && decoded.containsKey('articles')) {
        return (decoded['articles'] as List)
            .map((json) => Article.fromJson(json))
            .toList();
      }

      // Or backend returns just a list: [ {...}, {...} ]
      if (decoded is List) {
        return decoded.map((json) => Article.fromJson(json)).toList();
      }

      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to fetch articles');
    }
  }
}
