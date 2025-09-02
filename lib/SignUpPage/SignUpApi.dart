import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SignUpModel.dart';

class SignUpApi {
  static const String baseUrl = "http://10.112.215.78:8080/api/auth/signup";

  static Future<String> registerUser(SignUpModel user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return response.body; 
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
