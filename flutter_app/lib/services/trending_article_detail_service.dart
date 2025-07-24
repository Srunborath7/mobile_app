import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trending_article_detail.dart';
import '../connection/connection.dart';

class TrendingArticleDetailService {
  static Future<TrendingArticleDetail> fetchDetail(int articleId) async {
    final url = Uri.parse('$baseUrl/api/trending/detail/$articleId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TrendingArticleDetail.fromJson(data);
    } else {
      throw Exception('Failed to load trending article detail');
    }
  }
}
