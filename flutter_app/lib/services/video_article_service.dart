import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_article.dart';
import '../connection/connection.dart';

class VideoArticleService {
  static Future<List<VideoArticle>> fetchVideoArticles() async {
    final url = Uri.parse('$baseUrl/api/videos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      return jsonList.map((e) => VideoArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load video articles');
    }
  }
}
