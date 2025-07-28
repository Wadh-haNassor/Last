import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotspot.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  // Register user (protected if required)
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String password,
    String? token,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {
          'success': true,
          'user': User.fromJson(responseData),
          'message': 'Registration successful'
        };
      } else {
        String errorMessage = _handleHttpError(response.statusCode, responseData);
        return {
          'success': false,
          'message': errorMessage
        };
      }
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'Hakuna muunganisho wa mtandao. Hakikisha una intaneti'
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': User.fromJson(responseData),
          'token': responseData['token'],
          'message': 'Login successful'
        };
      } else {
        String errorMessage = _handleHttpError(response.statusCode, responseData);
        return {
          'success': false,
          'message': errorMessage
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Hakuna muunganisho wa mtandao. Hakikisha una intaneti'
      };
    }
  }

  // Get user-specific hotspots (protected)
  static Future<List<Hotspot>> getUserHotspots({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/hotspots'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Hotspot.fromJson(json)).toList();
      } else {
        print('Failed to get user hotspots: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Hotspots error: $e');
      return [];
    }
  }

  // Get all available hotspots (protected)
  static Future<List<Hotspot>> getAllHotspots({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hotspots'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Hotspot.fromJson(json)).toList();
      } else {
        print('Failed to get all hotspots: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Get all hotspots error: $e');
      return [];
    }
  }

  // Generic method for handling HTTP errors
  static String _handleHttpError(int statusCode, dynamic responseData) {
    if (responseData != null && responseData['message'] != null) {
      return responseData['message'];
    }

    switch (statusCode) {
      case 400:
        return 'Ombi sio sahihi';
      case 401:
        return 'Huruhusiwi';
      case 403:
        return 'Umekatazwa';
      case 404:
        return 'Haijapatikana';
      case 409:
        return 'Kuna mgongano';
      case 422:
        return 'Taarifa sio sahihi';
      case 500:
        return 'Hitilafu ya seva';
      case 502:
        return 'Server haifanyi kazi';
      case 503:
        return 'Huduma haipatikani';
      default:
        return 'Hitilafu isiyojulikana';
    }
  }
}
