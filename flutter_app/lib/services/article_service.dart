import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../connection/connection.dart';

class ArticleService {
  static Future<List<Article>> fetchArticles() async {
    final url = '$baseUrl/api/articles';
    print('Fetching articles from: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      List data;
      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded.containsKey('articles')) {
        data = decoded['articles'];
      } else {
        throw Exception('Unexpected JSON format');
      }

      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

}
