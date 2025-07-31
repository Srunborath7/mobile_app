class Article {
  final int id;
  final String title;
  final String? summary;
  final String? content;
  final String? imageUrl;      // use "image" or "full_image"
  final String? author;
  final int? categoryId;
  final String? categoryName;

  Article({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    this.imageUrl,
    this.author,
    this.categoryId,
    this.categoryName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['article_id'],
      title: json['title'] ?? '',
      summary: json['summary'],
      content: json['content'],
      imageUrl: json['full_image'] ?? json['image'], // prefer full_image if available
      author: json['author'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }
}
