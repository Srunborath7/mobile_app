import 'package:flutter/material.dart';

// Custom Navbar (unchanged)
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
      backgroundColor: Colors.white,
      elevation: 1,
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
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=$username',
                      ),
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

// HomePage using profile drawer
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;
  int roleId = 1;

  void handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const username = 'John Doe';
    const email = 'john.doe@example.com';
    final profileImageUrl = 'https://i.pravatar.cc/150?u=johndoe';

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        username: username,
        email: email,
        profileImageUrl: profileImageUrl,
      ),
      appBar: CustomNavbar(
        screenTitle: 'My App',
        username: username,
        userIs: roleId,
        onLogout: () {
          // handle logout here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out')),
          );
        },
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

// New CustomDrawer with profile info
class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profileImageUrl;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              const SizedBox(height: 20),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to edit profile page or do something
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Perform logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
