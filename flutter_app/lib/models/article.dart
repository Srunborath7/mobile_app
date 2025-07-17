class Article {
  final String title;
  final String summary;
  final String imageUrl;

  Article({
    required this.title,
    required this.summary,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title',
      summary: json['summary'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
