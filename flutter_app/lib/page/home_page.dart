import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layout/bottombar.dart';  // Adjust path based on your project structure

import 'login_page.dart'; // Your existing login page import
import 'edit_profile_page.dart';
import 'video_slideshow.dart';  // Adjust path as needed

import '../news_category/sports_news_screen.dart';
import '../news_category/technology_news_screen.dart';
import '../news_category/education_news_screen.dart';
import '../news_category/entertainment_news_screen.dart';
import '../news_category/finance_news_screen.dart';
import '../news_category/health_news_screen.dart';
import '../news_category/international_news_screen.dart';
import '../news_category/political_news_screen.dart';
import 'detail_homepage_new/article1.dart';


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
    Key? key,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.roleId,
  }) : super(key: key);

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

// Minimal implementation of CustomBottomNavigationBar
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

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
  const TechnologyNewsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(child: Text('Technology News'));
} /// delete class on homepage and then write this class into their own screen like (technology_screen, health_screen.....)

class HealthNewsScreen extends StatelessWidget {
  const HealthNewsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(child: Text('Health News'));
}

class FinanceNewsScreen extends StatelessWidget {
  const FinanceNewsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(child: Text('Health News'));
}

class InternationalNewsScreen extends StatelessWidget {
  const InternationalNewsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(child: Text('Health News'));
}

class EducationNewsScreen extends StatelessWidget {
  const EducationNewsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(child: Text('Health News'));
}

class EntertainmentNewsScreen extends StatelessWidget {
  const EntertainmentNewsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(child: Text('Health News'));
}

class PoliticalNewsScreen extends StatelessWidget {
  const PoliticalNewsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(child: Text('Health News'));
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

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
  }) {
    Widget imageWidget;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          imageUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
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

    return Padding(
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
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  List<Widget> _pages() {
    final List<Widget> basePages = [
      const Center(child: Text('Home Content')),
      const Center(child: Text('Videos Content')),
      const Center(child: Text('Trending Content')),
      const Center(child: Text('Settings Content')),
    ];

    if (widget.roleId == 1) {
      basePages.add(const Center(child: Text('Admin Panel Content')));
    }

    return basePages.map((page) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video carousel at top
            SizedBox(
              height: 250,
              child: const SimpleVideoCarousel(),
            ),

            const SizedBox(height: 15),

            // Category buttons
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

            ///body article in homepage news

            // Article Box 1
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Article1Page()),
                );
              },
              child: _articleBox(
                title: 'Latest Sports Update!',
                summary: 'Our local team made headlines after a stunning comeback...',
                imageUrl: 'https://images.unsplash.com/photo-1605296867304-46d5465a13f1',
              ),
            ),


            // Article Box 2
            _articleBox(
              title: 'Big Tech Breakthrough',
              summary: 'A major announcement in the tech world just happened...',
              imageUrl: 'https://images.unsplash.com/photo-1518779578993-ec3579fee39f',
            ),

            // Article Box 3
            _articleBox(
              title: 'Healthcare Revolution',
              summary: 'New AI system detects early signs of disease...',
              imagePath: 'assets/image/pf.jpg',
            ),

            // Article Box 4
            _articleBox(
              title: 'education Revolution',
              summary: 'New AI system detects early signs of disease...',
              imagePath: 'assets/image/n1.png',
            ),

            // Article Box 5
            _articleBox(
              title: 'game Revolution',
              summary: 'New AI system detects early signs of disease...',
              imageUrl: 'https://images.unsplash.com/photo-1588776814546-ec7e4c85f180',
            ),

            // Article Box 6
            _articleBox(
              title: 'entertainment Revolution',
              summary: 'New AI system detects early signs of disease...',
              imageUrl: 'https://images.unsplash.com/photo-1588776814546-ec7e4c85f180',
            ),

            const SizedBox(height: 20),

            // Bottom content
            page,
          ],
        ),
      );
    }).toList();
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
