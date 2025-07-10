import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layout/bottombar.dart';  // Adjust path based on your project structure

import 'login_page.dart'; // Your existing login page import

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

// CustomDrawer as you provided
class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profileImageUrl;
  final int roleId;
  final Function(int) onItemTapped;

  const CustomDrawer({
    Key? key,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.roleId,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      {'icon': Icons.home, 'title': 'Home'},
      {'icon': Icons.video_collection, 'title': 'Videos'},
      {'icon': Icons.trending_up, 'title': 'Trending'},
      {'icon': Icons.settings, 'title': 'Settings'},
    ];

    if (roleId == 1) {
      drawerItems.add({'icon': Icons.admin_panel_settings, 'title': 'Admin Panel'});
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Welcome message and account info
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
                        'You are using account: ${username.replaceFirst("Welcome!", "").trim()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Role ID: $roleId',
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),



                // Right side: tappable profile image with dialog
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 10,
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
                              if (roleId == 1)
                                const Text(
                                  'Admin Account',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop(); // Close dialog
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
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


          // Your drawer menu items...
          ...drawerItems.asMap().entries.map((entry) {
            int idx = entry.key;
            var item = entry.value;
            return ListTile(
              leading: Icon(item['icon'] as IconData),
              title: Text(item['title'] as String),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(idx);
              },
            );
          }).toList(),
        ],
      ),
    );

  }
}

// Your MyHomePage widget definition with state
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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _pages() {
    final pages = [
      const Center(child: Text('Home Screen')),
      const Center(child: Text('Video Screen')),
      const Center(child: Text('Trending Screen')),
      const Center(child: Text('Settings Screen')),
    ];

    if (widget.roleId == 1) {
      pages.add(const Center(child: Text('Admin Panel Screen')));
    }

    return pages;
  }

  String _getScreenTitle(int index) {
    final titles = ['Home', 'Videos', 'Trending', 'Settings'];
    if (widget.roleId == 1) {
      titles.add('Admin Panel');
    }
    return titles[index];
  }

  void _onItemTapped(int index) {
    print('Tapped index: $index'); // Debug print
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
        username: widget.title,  // Your username here
        userIs: widget.roleId,
        onLogout: () {
          // Your logout logic here if needed
        },
      ),
      drawer: CustomDrawer(
        username: widget.title,
        email: 'john.doe@example.com',
        profileImageUrl: 'https://i.pravatar.cc/150?u=${widget.title}',
        roleId: widget.roleId,
        onItemTapped: _onItemTapped,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

}
