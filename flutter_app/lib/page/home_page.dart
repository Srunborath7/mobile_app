import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../connection/connection.dart';

import '../drawer_content_page/app_feedback_page.dart';
import '../drawer_content_page/privacy_page.dart';
import '../drawer_content_page/term_of_use_page.dart';

import 'login_page.dart';
import 'video_slideshow.dart';

import '../news_category/sports_news_screen.dart';
import '../news_category/technology_news_screen.dart';
import '../news_category/education_news_screen.dart';
import '../news_category/entertainment_news_screen.dart';
import '../news_category/finance_news_screen.dart';
import '../news_category/health_news_screen.dart';
import '../news_category/international_news_screen.dart';
import '../news_category/political_news_screen.dart';

import '../models/article.dart';
import '../services/article_service.dart';
import 'detail_article/article_detail_page.dart';

import '../video_page/video_article_page.dart';

import '../trending_page/trending_article_page.dart';

import '../user_profile/profile_screen.dart';
import '../screens/post_page.dart';

import 'admin_panel_page/admin_dashboard_screen.dart';

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
  String getInitial(String name) {
    if (name.trim().isEmpty) return '?';
    return name.trim().split(' ').first[0].toUpperCase();
  }

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Box
              Container(
                width: 160,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search........',
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    suffixIcon: Icon(Icons.search, size: 20),
                  ),
                  style: TextStyle(fontSize: 14),
                  onSubmitted: (value) {
                    // TODO: Implement search logic here
                    print('Search for: $value');
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Profile Avatar
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Text(
                    getInitial(username),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatefulWidget {
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
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }
  String Initial(String name) {
    if (name.trim().isEmpty) return '?';
    return name.trim().split(' ').first[0].toUpperCase();
  }
  Future<void> _saveNotificationPreference(bool enabled) async {
    ///setState(() {
      ///notificationsEnabled = !notificationsEnabled;
    ///});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', enabled);


    /*
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Notifications'),
        content: Text(
          notificationsEnabled
              ? 'Notifications have been turned ON!'
              : 'Notifications have been turned OFF!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

     */

    // TODO: Add actual notification permission and enable/disable logic here
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
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
                              'Account Name: ${widget.username.replaceFirst("Welcome!", "").trim()}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.roleId == 1 ? 'Admin Account' : 'User Account',
                              style: TextStyle(
                                color: widget.roleId == 1
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
                                      backgroundColor: Colors.deepPurple.shade100,
                                      child: Text(

                                        Initial(widget.username),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      widget.username,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.roleId == 1 ? 'Admin Account' : 'User Account',
                                      style: TextStyle(
                                        color: widget.roleId == 1 ? Colors.deepPurple : Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.email,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.deepPurple.shade100,
                          child: Text(
                            Initial(widget.username),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                /// Privacy Policy
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Colors.deepPurple),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                    );
                  },
                ),

                /// Terms of Use
                ListTile(
                  leading: const Icon(Icons.article_outlined, color: Colors.deepPurple),
                  title: const Text('Terms of Use'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TermsOfUsePage()),
                    );
                  },
                ),

                /// App Feedback
                ListTile(
                  leading: const Icon(Icons.feedback_outlined, color: Colors.deepPurple),
                  title: const Text('App Feedback'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AppFeedbackPage()),
                    );
                  },
                ),

                /// Notifications
                if (widget.roleId != 1 && widget.roleId != 2)

                  ListTile(
                    leading: Icon(
                      Icons.notifications_active_outlined,
                      color: notificationsEnabled ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      notificationsEnabled ? 'Notifications ON' : 'Notifications OFF',
                      style: TextStyle(
                        color: notificationsEnabled ? Colors.green : Colors.grey,
                      ),
                    ),
                    trailing: Switch(
                      value: notificationsEnabled,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
                        _saveNotificationPreference(value);
                      },
                    ),
                  ),

                ListTile(
                  leading: const Icon(Icons.system_update_alt_outlined, color: Colors.deepPurple),
                  title: const Text('Check for Updates'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer

                    // Show update check dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) => AlertDialog(
                        title: const Text(
                          'Update Check',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'You are using version 1.0.0.',
                              style: TextStyle(fontSize: 23),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Your version is very lasted version',
                              style: TextStyle(fontSize: 19, color: Colors.cyan),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );




                    // In real app, you might call an API here to check version.
                  },
                ),


                /// Logout
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
          ),

          // Footer section
          const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: const [
                Text(
                  'App Version: 1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  'Developed by Khang & Borath',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int roleId;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.video_collection), label: 'Videos'),
      const BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trending'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Profile'),
    ];

    if (roleId == 1 || roleId == 2) {
      items.add(const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings), label: 'Admin'));
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
  final String fullName;
  final String email;
  final String address;
  final String phone;
  final String dob;

  const MyHomePage({
    super.key,
    required this.title,
    required this.token,
    required this.roleId,
    this.userId,
    required this.fullName,
    required this.email,
    required this.address,
    required this.phone,
    required this.dob,
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
                  print('🟢 Tapped article ID: ${article.id}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailPage(articleId: article.id),
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

      const VideoArticlePage(),

      const TrendingArticlePage(),
      ProfileScreen(
        userId: widget.userId ?? 0,
        username: widget.title,
      ),
    ];

    if (widget.roleId == 1 || widget.roleId == 2) {
      basePages.add(const AdminDashboardScreen());
    }

    return basePages;
  }

  String _getScreenTitle(int index) {
    final titles = ['Home', 'Videos', 'Trending', 'Profile'];
    if (widget.roleId == 1 || widget.roleId == 2) {
      titles.add('Admin Panel');
    }
    return titles[index];
  }

  void _onItemTapped(int index) {
    final maxIndex = widget.roleId == 1 || widget.roleId ==2 ? 4 : 3;
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
        email: widget.email,
        profileImageUrl: 'https://i.pravatar.cc/150?u=${widget.title}',
        roleId: widget.roleId,
      ),
      body: pages[_selectedIndex],

      floatingActionButton: widget.roleId == 1 || widget.roleId == 2
          ? SizedBox(
        width: 60,
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PostPage()));
          },
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.post_add, size: 30, color: Colors.cyan,),
        ),
      )
          : null,

      floatingActionButtonLocation: CustomFabLocation(offsetY: 80),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        roleId: widget.roleId,
      ),
    );
  }
}

// Put this class outside the widget class (e.g., below it or in separate file)
class CustomFabLocation extends FloatingActionButtonLocation {
  final double offsetY;

  CustomFabLocation({this.offsetY = 100.200});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2;
    final double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height - offsetY;
    return Offset(fabX, fabY);
  }
}
