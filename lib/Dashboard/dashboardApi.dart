import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboardModel.dart';

class DashboardApi {
  static const String baseUrl = "http://10.112.215.78:8080"; 
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded);
  }
  static Future<List<Task>> getTasksByUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        throw Exception("User not logged in or token missing");
      }

      final payload = parseJwt(token);
      final userIdStr = payload['id'] ?? payload['sub']; // depends on your token
       print("userIDdddd${userIdStr}");
      if (userIdStr == null) throw Exception("User ID not found in token");

      final userId = int.parse(userIdStr);

      final url = Uri.parse("$baseUrl/api/tasks/user/$userId");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception(
          "Failed to fetch tasks: ${response.statusCode} ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
      rethrow;
    }
  }

   static Future<Task> addTask(String title, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null) throw Exception("User not logged in or token missing");

    final url = Uri.parse("$baseUrl/api/tasks");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "description": description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception(
          "Failed to create task: ${response.statusCode} ${response.body}");
    }
  }
}
