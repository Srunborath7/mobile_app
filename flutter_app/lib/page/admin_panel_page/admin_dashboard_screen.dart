import 'package:flutter/material.dart';
import '../../services/user_stats_service.dart';
import '../../services/article_service.dart';
import '../../models/article.dart';
import 'all_users_screen.dart';
import '../register_page.dart';
import 'EditArticleScreen.dart';
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<int> _userCountFuture;

  @override
  void initState() {
    super.initState();
    _userCountFuture = UserStatsService.fetchUserCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<int>(
          future: _userCountFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userCount = snapshot.data ?? 0;
              return ListView(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(canSelectRole: true),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Register New User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DashboardCard(
                    icon: Icons.people,
                    title: 'Total Users',
                    value: userCount.toString(),
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AllUsersScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'All Articles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const ArticleList(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, size: 40, color: color),
          title: Text(title, style: const TextStyle(fontSize: 18)),
          subtitle: Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ======= ArticleList widget =======
// Make sure you have ArticleService and Article model ready

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = ArticleService.fetchArticles();
  }

  Future<void> _deleteArticle(int articleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Article'),
        content: const Text('Are you sure you want to delete this article?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ArticleService.deleteArticle(articleId); // implement deleteArticle in ArticleService
      setState(() {
        _articlesFuture = ArticleService.fetchArticles();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article deleted')),
      );
    }
  }

  // void _updateArticle(Article article) {
  //   // Navigate to update article screen (implement this page yourself)
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Update feature not implemented for: ${article.title}')),
  //   );
  // }
  void _updateArticle(Article article) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateArticlePage(article: article),
      ),
    );

    if (updated == true) {
      setState(() {
        _articlesFuture = ArticleService.fetchArticles();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article updated')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading articles: ${snapshot.error}'));
        }
        final articles = snapshot.data ?? [];

        if (articles.isEmpty) {
          return const Text('No articles found.');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: article.imageUrl != null
                    ? Image.network(
                  article.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.article),
                title: Text(article.title),
                subtitle: Text(article.summary ?? 'No summary'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _updateArticle(article),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteArticle(article.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
