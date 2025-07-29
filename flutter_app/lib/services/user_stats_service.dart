import 'dart:convert';
import 'package:http/http.dart' as http;

class UserStatsService {
  static Future<int> fetchUserCount() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/users/user-count'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['totalUsers'] ?? 0;
    } else {
      throw Exception('Failed to fetch user count');
    }
  }
}
