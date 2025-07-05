import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final ValueChanged<int> onItemTapped;
  final int selectedIndex;

  const CustomDrawer({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _buildListTile(context, 0, Icons.home, 'Home'),
          _buildListTile(context, 1, Icons.ondemand_video, 'Videos'),
          _buildListTile(context, 2, Icons.trending_up, 'Trending'),
          _buildListTile(context, 3, Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, int index, IconData icon, String title) {
    return ListTile(
      selected: selectedIndex == index,
      leading: Icon(icon, color: selectedIndex == index ? Colors.deepPurple : null),
      title: Text(title),
      onTap: () => onItemTapped(index),
    );
  }
}
