import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final int roleId;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.video_collection),
            title: const Text('Videos'),
            selected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Trending'),
            selected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: selectedIndex == 3,
            onTap: () => onItemTapped(3),
          ),
          if (roleId == 1)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Panel'),
              selected: selectedIndex == 4,
              onTap: () => onItemTapped(4),
            ),
        ],
      ),
    );
  }
}
