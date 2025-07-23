import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_detail.dart';
import '../connection/connection.dart';

class ArticleDetailService {
  static Future<ArticleDetail> fetchArticleDetailById(int id) async {
    final url = '$baseUrl/api/articles/detail/$id';
    print('Fetching article detail from: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('Decoded JSON: $decoded');

      if (decoded is Map && decoded.containsKey('article')) {
        print('Returning decoded["article"]');
        return ArticleDetail.fromJson(decoded['article']);
      }

      print('Returning decoded directly');
      return ArticleDetail.fromJson(decoded);
    } else {
      print('❌ Failed to fetch article');
      throw Exception('Failed to load article detail');
    }
  }

}
