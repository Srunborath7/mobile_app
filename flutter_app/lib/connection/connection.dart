import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.10.0.61:3000';

Future<void> testConnection() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200 || response.statusCode == 404) {
      print('Connection successful to $baseUrl');
    } else {
      print('Server responded but with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Connection failed: $e');
  }
}
