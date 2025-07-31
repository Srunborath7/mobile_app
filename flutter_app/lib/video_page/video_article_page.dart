import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../models/video_article.dart';
import '../services/video_article_service.dart';
import '../connection/connection.dart';

class VideoArticlePage extends StatefulWidget {
  const VideoArticlePage({super.key});

  @override
  State<VideoArticlePage> createState() => _VideoArticlePageState();
}

class _VideoArticlePageState extends State<VideoArticlePage> {
  late Future<List<VideoArticle>> _futureVideos;

  @override
  void initState() {
    super.initState();
    _futureVideos = VideoArticleService.fetchVideoArticles();
  }

  String _buildFullUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$baseUrl/$path';
  }

  Widget _videoBox(VideoArticle video) {
    return GestureDetector(
      onTap: () async {
        final urlString = video.videoUrl.startsWith('http')
            ? video.videoUrl
            : 'https://www.youtube.com/watch?v=${video.videoUrl}';

        final url = Uri.parse(urlString);
        print("Tapped video URL: $url");

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch: $url');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot open the video link')),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                _buildFullUrl(video.thumbnailUrl),
                width: double.infinity,
                height: 180,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Text(video.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VideoArticle>>(
      future: _futureVideos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No videos found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: snapshot.data!.map((video) => _videoBox(video)).toList(),
          ),
        );
      },
    );
  }
}
