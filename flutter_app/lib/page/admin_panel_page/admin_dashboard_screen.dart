import 'package:flutter/material.dart';
import '../../services/user_stats_service.dart';
import 'all_users_screen.dart';
import '../register_page.dart';


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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  const SizedBox(height: 16),


                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(
                          builder: (context) => const RegisterPage(canSelectRole: true), // or false
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

                  // Add more cards here if needed
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

