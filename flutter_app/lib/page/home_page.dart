import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layout/bottombar.dart';  // Adjust path based on your project structure

import 'login_page.dart';
import 'edit_profile_page.dart';
import 'video_slideshow.dart';

import '../news_category/sports_news_screen.dart';
import '../news_category/technology_news_screen.dart';
import '../news_category/education_news_screen.dart';
import '../news_category/entertainment_news_screen.dart';
import '../news_category/finance_news_screen.dart';
import '../news_category/health_news_screen.dart';
import '../news_category/international_news_screen.dart';
import '../news_category/political_news_screen.dart';

import '../connection/connection.dart';

import '../models/article.dart';
import '../services/article_service.dart';
import 'detail_article/article_detail_page.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String screenTitle;
  final String username;
  final int userIs;
  final VoidCallback? onLogout;

  const CustomNavbar({
    super.key,
    required this.screenTitle,
    required this.username,
    required this.userIs,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage('assets/image/pf.jpg'),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(
        screenTitle,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 18,
                      backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?u=$username'),
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profileImageUrl;
  final int roleId;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Account: ${username.replaceFirst("Welcome!", "").trim()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        roleId == 1 ? 'Admin Account' : 'User Account',
                        style: TextStyle(
                          color: roleId == 1
                              ? Colors.amberAccent
                              : Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(profileImageUrl),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                roleId == 1
                                    ? 'Admin Account'
                                    : 'User Account',
                                style: TextStyle(
                                  color: roleId == 1
                                      ? Colors.deepPurple
                                      : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Videos'),
      BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trending'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ];
    if (currentIndex == 4 || items.length == 4) {
      items.add(BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'));
    }
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: BottomNavigationBarType.fixed,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String token;
  final int roleId;
  final int? userId;

  const MyHomePage({
    super.key,
    required this.title,
    required this.token,
    required this.roleId,
    this.userId,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class TechnologyNewsScreen extends StatelessWidget {
  const TechnologyNewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Technology News'));
}

class HealthNewsScreen extends StatelessWidget {
  const HealthNewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Health News'));
}

class FinanceNewsScreen extends StatelessWidget {
  const FinanceNewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Finance News'));
}

class InternationalNewsScreen extends StatelessWidget {
  const InternationalNewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('International News'));
}

class EducationNewsScreen extends StatelessWidget {
  const EducationNewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Education News'));
}

class EntertainmentNewsScreen extends StatelessWidget {
  const EntertainmentNewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Entertainment News'));
}

class PoliticalNewsScreen extends StatelessWidget {
  const PoliticalNewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Political News'));
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late Future<List<Article>> _futureArticles;

  @override
  void initState() {
    super.initState();
    _futureArticles = ArticleService.fetchArticles();
    _futureArticles.then((value) {
      print('Fetched ${value.length} articles in initState');
    }).catchError((error) {
      print('Error fetching articles in initState: $error');
    });
  }

  String _buildFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '$baseUrl/$imageUrl';
  }

  Widget _categoryButton(String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Text(title),
    );
  }

  Widget _articleBox({
    required String title,
    required String summary,
    String? imageUrl,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    Widget imageWidget;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final fullUrl = _buildFullImageUrl(imageUrl);
      print('Loading image from: $fullUrl');

      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          fullUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Failed to load image: $error');
            return Container(
              height: 180,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
            );
          },
        ),
      );
    } else if (imagePath != null && imagePath.isNotEmpty) {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.asset(
          imagePath,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      imageWidget = Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget,
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isNotEmpty ? title : 'No Title',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      summary.isNotEmpty ? summary : 'No Summary',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesFromAPI() {
    return FutureBuilder<List<Article>>(
      future: _futureArticles,
      builder: (context, snapshot) {
        print('FutureBuilder state: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Waiting for articles...');
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error in FutureBuilder: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No articles found or empty data');
          return const Center(child: Text('No articles found'));
        } else {
          final articles = snapshot.data!;
          print('Building UI with ${articles.length} articles');
          return Column(
            children: articles.map((article) {
              print('Article: ${article.title}');
              return _articleBox(
                title: article.title,
                summary: article.summary,
                imageUrl: article.imageUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailPage(articleId: article.id), // pass article id only
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }

  List<Widget> _pages() {
    final basePages = [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 250, child: const SimpleVideoCarousel()),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 55,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _categoryButton('Sports', const SportsNewsScreen()),
                      const SizedBox(width: 12),
                      _categoryButton('Technology', const TechnologyNewsScreen()),
                      const SizedBox(width: 12),
                      _categoryButton('Health', const HealthNewsScreen()),
                      const SizedBox(width: 12),
                      _categoryButton('Finance', const FinanceNewsScreen()),
                      const SizedBox(width: 12),
                      _categoryButton('International', const InternationalNewsScreen()),
                      const SizedBox(width: 12),
                      _categoryButton('Education', const EducationNewsScreen()),
                      const SizedBox(width: 12),
                      _categoryButton('Entertainment', const EntertainmentNewsScreen()),
                      const SizedBox(width: 12),
                      _categoryButton('Political', const PoliticalNewsScreen()),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildArticlesFromAPI(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      const Center(child: Text('Videos Content')),
      const Center(child: Text('Trending Content')),
      const Center(child: Text('Settings Content')),
    ];

    if (widget.roleId == 1) {
      basePages.add(const Center(child: Text('Admin Panel Content')));
    }

    return basePages;
  }

  String _getScreenTitle(int index) {
    final titles = ['Home', 'Videos', 'Trending', 'Settings'];
    if (widget.roleId == 1) {
      titles.add('Admin Panel');
    }
    return titles[index];
  }

  void _onItemTapped(int index) {
    final maxIndex = widget.roleId == 1 ? 4 : 3;
    if (index > maxIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages();

    return Scaffold(
      appBar: CustomNavbar(
        screenTitle: _getScreenTitle(_selectedIndex),
        username: widget.title,
        userIs: widget.roleId,
        onLogout: () {},
      ),
      drawer: CustomDrawer(
        username: widget.title,
        email: 'john.doe@example.com',
        profileImageUrl: 'https://i.pravatar.cc/150?u=${widget.title}',
        roleId: widget.roleId,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
