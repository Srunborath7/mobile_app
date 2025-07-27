import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileService {
  static Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/profile/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch profile: ${response.body}');
      return null;
    }
  }
}
