class Article {
  final int id;
  final String title;
  final String summary;
  final String imageUrl;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
