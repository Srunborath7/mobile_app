class ArticleDetail {
  final int id;
  final String title;
  final String content;
  final String author;
  final String? fullImage;

  ArticleDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    this.fullImage,
  });

  factory ArticleDetail.fromJson(Map<String, dynamic> json) {
    return ArticleDetail(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      fullImage: json['fullImage'], // adapt if your API uses another key
    );
  }
}
