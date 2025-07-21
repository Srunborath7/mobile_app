import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SimpleVideoCarousel extends StatefulWidget {
  const SimpleVideoCarousel({super.key});

  @override
  State<SimpleVideoCarousel> createState() => _SimpleVideoCarouselState();
}

class _SimpleVideoCarouselState extends State<SimpleVideoCarousel> {
  final List<String> videoUrls = [
    'https://youtu.be/OT4cDorZq68?si=o9R5ynjQWbE5F_0Y',
    // Add more URLs here
  ];

  late final List<YoutubePlayerController> _controllers;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controllers = videoUrls.map((url) {
      final videoId = YoutubePlayer.convertUrlToId(url)!;
      return YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          loop: true,
        ),
      );
    }).toList();

    if (_controllers.isNotEmpty) {
      _controllers.first.play();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _controllers[_currentIndex].pause();
      _currentIndex = index;
      _controllers[_currentIndex].play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: _controllers.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return YoutubePlayer(
            controller: _controllers[index],
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
          );
        },
      ),
    );
  }
}
