class TrendingArticle {
  final int id;
  final String title;
  final String summary;
  final String imageUrl;

  TrendingArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
  });

  factory TrendingArticle.fromJson(Map<String, dynamic> json) {
    return TrendingArticle(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      summary: json['summary'] ?? 'No Summary',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
