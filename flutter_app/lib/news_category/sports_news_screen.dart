import 'package:flutter/material.dart';

class SportsNewsScreen extends StatelessWidget {
  const SportsNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example list of sports news headlines
    final List<String> newsHeadlines = [
      'Local Team Wins Championship!',
      'Star Player Injured in Training',
      'Upcoming Sports Events This Week',
      'Interview with the Coach',
      'Top 10 Moments in Sports History',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports News'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: newsHeadlines.length,
        separatorBuilder: (context, index) => const Divider(height: 20),
        itemBuilder: (context, index) {
          final headline = newsHeadlines[index];
          return ListTile(
            leading: const Icon(Icons.sports_soccer, color: Colors.deepPurple),
            title: Text(
              headline,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // On tap, you could navigate to a detailed news page (optional)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Clicked: $headline')),
              );
            },
          );
        },
      ),
    );
  }
}
