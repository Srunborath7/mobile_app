import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.green[800],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedLabelStyle: const TextStyle(color: Colors.pink),
      unselectedLabelStyle: TextStyle(color: Colors.yellow),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: "Videos"),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "Trending"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}

