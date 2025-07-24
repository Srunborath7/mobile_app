

class VideoArticle {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;

  VideoArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  factory VideoArticle.fromJson(Map<String, dynamic> json) {
    return VideoArticle(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'], // YouTube link from MySQL
    );
  }
}
