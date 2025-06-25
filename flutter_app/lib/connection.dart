import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.56.1:3000';

Future<void> testConnection() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200 || response.statusCode == 404) {
      // 404 means route doesn't exist but server is reachable
      print('Connection successful to $baseUrl');
    } else {
      print('Server responded but with status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}
