import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trending_article.dart';
import '../connection/connection.dart'; // for baseUrl

class TrendingArticleService {
  static Future<List<TrendingArticle>> fetchTrendingArticles() async {
    final url = Uri.parse('$baseUrl/api/trending');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TrendingArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending articles');
    }
  }
}

