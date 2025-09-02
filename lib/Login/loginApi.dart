import 'dart:convert';
import 'package:http/http.dart' as http;
import 'loginModel.dart';

class LoginApi {
  static const String baseUrl = "http://10.112.215.78:8080/api/auth/login";

  static Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Data${data}");
        return LoginResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Failed to login: $e");
    }
  }
}
