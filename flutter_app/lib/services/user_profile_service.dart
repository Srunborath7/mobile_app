import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileService {
  static Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/profile/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['profile']; // Adjust depending on your API format
    } else {
      print('Error fetching profile: ${response.body}');
      return null;
    }
  }

}
