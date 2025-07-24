class TrendingArticleDetail {
  final int id;
  final int trendingArticleId;
  final String content;
  final String fullImageUrl;

  TrendingArticleDetail({
    required this.id,
    required this.trendingArticleId,
    required this.content,
    required this.fullImageUrl,
  });

  factory TrendingArticleDetail.fromJson(Map<String, dynamic> json) {
    return TrendingArticleDetail(
      id: json['id'],
      trendingArticleId: json['trending_article_id'],
      content: json['content'],
      fullImageUrl: json['full_image_url'],
    );
  }
}
