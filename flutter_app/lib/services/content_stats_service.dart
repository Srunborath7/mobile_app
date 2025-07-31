import 'dart:convert';
import 'package:http/http.dart' as http;
import '../connection/connection.dart';

class ContentStatsService {
  static Future<Map<String, int>> fetchContentCounts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/count/get-counts'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'articleCount': data['articleCount'],
        'videoArticleCount': data['videoArticleCount'],
        'trendingArticleCount': data['trendingArticleCount'],
      };
    } else {
      throw Exception('Failed to fetch content counts');
    }
  }
}
