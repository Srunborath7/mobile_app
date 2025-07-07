import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../layout/navbar.dart';
import '../layout/drawer_content.dart';
import '../layout/buttombar.dart';
import 'login_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Screen'));
  }
}

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Video Screen'));
  }
}

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Trending Screen'));
  }
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Screen'));
  }
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Admin Panel Screen'));
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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _pages() {
    final pages = [
      const HomeScreen(),
      const VideoScreen(),
      const TrendingScreen(),
      const SettingScreen(),
    ];

    if (widget.roleId == 1) {
      pages.add(const AdminPanel());
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages();

    return Scaffold(
      appBar: CustomNavbar(
        screenTitle: _getScreenTitle(_selectedIndex),
        username: widget.title,
        userIs: widget.roleId,
        onLogout: _logout,
      ),
      drawer: CustomDrawer(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
        roleId: widget.roleId,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
