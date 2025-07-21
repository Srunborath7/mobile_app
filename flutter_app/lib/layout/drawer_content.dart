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
    final drawerItems = [
      {'icon': Icons.sports_soccer, 'title': 'Sport News'},
      {'icon': Icons.computer, 'title': 'Technology News'},
      {'icon': Icons.public, 'title': 'World News'},
      {'icon': Icons.movie, 'title': 'Entertainment'},
    ];

    if (roleId == 1) {
      drawerItems.add({'icon': Icons.admin_panel_settings, 'title': 'Admin Panel'});
    }

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ...drawerItems.asMap().entries.map((entry) {
            int idx = entry.key;
            var item = entry.value;
            return ListTile(
              leading: Icon(item['icon'] as IconData),
              title: Text(item['title'] as String),
              selected: selectedIndex == idx,
              selectedTileColor: Colors.deepPurple.shade100,
              onTap: () {
                Navigator.pop(context); // Close drawer
                onItemTapped(idx);      // Notify parent
              },
            );
          }),
        ],
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  final int roleId;

  const MyHomePage({super.key, required this.roleId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final _pages = [
    Center(child: Text('Sport News Screen')),
    Center(child: Text('Technology News Screen')),
    Center(child: Text('World News Screen')),
    Center(child: Text('Entertainment Screen')),
    Center(child: Text('Admin Panel Screen')),
  ];


  void _onItemTapped(int index) {
    final maxIndex = widget.roleId == 1 ? 4 : 3; // Max valid index depending on role
    if (index > maxIndex) return; // Ignore invalid index

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final drawerItemsCount = widget.roleId == 1 ? 5 : 4;
    final pages = widget.roleId == 1 ? _pages : _pages.sublist(0, 4);
    final safeSelectedIndex = _selectedIndex.clamp(0, drawerItemsCount - 1);

    return Scaffold(
      appBar: AppBar(title: Text('My App')),
      drawer: CustomDrawer(
        selectedIndex: safeSelectedIndex,
        onItemTapped: _onItemTapped,
        roleId: widget.roleId,
      ),
      body: pages[safeSelectedIndex],
    );
  }
}
