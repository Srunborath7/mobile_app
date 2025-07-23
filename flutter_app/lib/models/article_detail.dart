class ArticleDetail {
  final int id;
  final int articleId;
  final String content;
  final String author;
  final String fullImage;

  ArticleDetail({
    required this.id,
    required this.articleId,
    required this.content,
    required this.author,
    required this.fullImage,
  });


  factory ArticleDetail.fromJson(Map<String, dynamic> json) {
    return ArticleDetail(
      id: json['id'] ?? 0,
      articleId: json['article_id'] ?? 0,
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      fullImage: json['full_image'] ?? '',
    );
  }

}

