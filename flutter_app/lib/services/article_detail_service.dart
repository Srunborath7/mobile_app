// lib/services/article_detail_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_detail.dart';
import '../connection/connection.dart';

class ArticleDetailService {
  static Future<ArticleDetail> fetchArticleDetailById(int id) async {
    final url = '$baseUrl/api/articles/$id';  // Make sure this matches your backend route
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // If your API response wraps the article inside a key 'article', extract it, else use decoded directly
      if (decoded is Map && decoded.containsKey('article')) {
        return ArticleDetail.fromJson(decoded['article']);
      }

      return ArticleDetail.fromJson(decoded);
    } else {
      throw Exception('Failed to load article detail with id $id');
    }
  }
}
