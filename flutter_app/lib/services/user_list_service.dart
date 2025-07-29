import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final int roleId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role_title'] ?? json['role'], // adjust if backend returns role_title or role
      roleId: json['role_id'] ?? 0, // adjust to your backend key name
    );
  }
}


class UserListService {
  static Future<List<User>> fetchAllUsers() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/users/all-users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((u) => User.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<bool> deleteUser(int userId) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/delete/$userId');

    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      print('Delete failed: ${response.statusCode} ${response.body}');
      return false;
    }
  }

}
