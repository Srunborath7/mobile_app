import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/article_detail.dart';
import '../connection/connection.dart';

class ArticleService {
  /// Fetch a single article by ID with full detail (content, author, etc.)
  static Future<ArticleDetail> fetchArticleById(int id) async {
    final url = '$baseUrl/api/articles/full/$id'; // Make sure backend supports this route
    print('Fetching article by ID from: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('Decoded JSON: $decoded');

      // Some APIs wrap the article inside an 'article' key, handle both cases
      if (decoded is Map<String, dynamic> && decoded.containsKey('article')) {
        return ArticleDetail.fromJson(decoded['article']);
      }

      return ArticleDetail.fromJson(decoded);
    } else {
      throw Exception('Failed to load article with id $id. Status code: ${response.statusCode}');
    }
  }

  /// Fetch list of all articles
  static Future<List<Article>> fetchArticles() async {
    final url = '$baseUrl/api/articles/full';
    print('Fetching all articles from: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey('articles')) {
        final articlesJson = decoded['articles'] as List<dynamic>;
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      }

      if (decoded is List<dynamic>) {
        return decoded.map((json) => Article.fromJson(json)).toList();
      }

      throw Exception('Unexpected response format: Expected List or Map with "articles" key.');
    } else {
      throw Exception('Failed to fetch articles. Status code: ${response.statusCode}');
    }
  }

  /// fetch article by category
  static Future<List<Article>> fetchArticlesByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/article/category/$category'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles for category $category');
    }
  }


  /// Delete an article by ID
  static Future<void> deleteArticle(int articleId) async {
    final url = Uri.parse('$baseUrl/api/articles/full/$articleId');
    print('Deleting article with ID $articleId at: $url');

    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Article deleted successfully');
      return;
    } else {
      throw Exception('Failed to delete article with id $articleId. Status code: ${response.statusCode}');
    }
  }
  static Future<void> updateArticle(Article article) async {
    final url = Uri.parse('$baseUrl/api/articles/full/${article.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': article.title,
        'summary': article.summary,
        'content': article.content,
        'author': article.author,
        'image': article.imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update article');
    }
  }

}
