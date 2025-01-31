import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

class AuthService {
  Future<User?> login(String username, String password) async {
    try {
      // Load and parse the JSON file
      final String jsonString = await rootBundle.loadString('assets/data/users.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> users = jsonData['users'];

      // Find user with matching credentials
      final userJson = users.firstWhere(
        (user) => user['username'] == username && user['password'] == password,
        orElse: () => null,
      );

      if (userJson != null) {
        return User.fromJson(userJson);
      }

      return null;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
