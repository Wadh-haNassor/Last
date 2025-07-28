import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/hotspot.dart';
import './api_service.dart';

class UserService extends ChangeNotifier {
  User? _currentUser;
  String? _authToken;
  List<Hotspot> _userHotspots = [];
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  String? get authToken => _authToken;
  List<Hotspot> get userHotspots => List.unmodifiable(_userHotspots);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _clearError() {
    _errorMessage = null;
  }

  void _setError(String message) {
    _errorMessage = message;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      final result = await ApiService.loginUser(email, password);
      
      if (result['success']) {
        _currentUser = result['user'];
        _authToken = result['token'];

        // Store token for persistence
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _authToken!);

        // Load user hotspots with token
        if (_currentUser != null && _authToken != null) {
          _userHotspots = await ApiService.getUserHotspots(
            userId: _currentUser!.id,
            token: _authToken!,
          );
        }

        _setLoading(false);
        return true;
      } else {
        _setError(result['message'] ?? 'Imeshindikana kuingia');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Hitilafu ya mtandao: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Use the current authToken (if admin is registering others, etc.)
      final result = await ApiService.registerUser(
        name: name,
        email: email,
        phone: phone,
        location: location,
        password: password,
        token: _authToken,
      );
      
      if (result['success']) {
        _currentUser = result['user'];
        _userHotspots = [];
        _setLoading(false);
        return true;
      } else {
        _setError(result['message'] ?? 'Imeshindikana kujisajili');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Hitilafu ya mtandao: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> refreshUserHotspots() async {
    if (_currentUser != null && _authToken != null) {
      try {
        _userHotspots = await ApiService.getUserHotspots(
          userId: _currentUser!.id,
          token: _authToken!,
        );
        notifyListeners();
      } catch (e) {
        _setError('Imeshindikana kupata hotspots');
        notifyListeners();
      }
    }
  }

  void logout() async {
    _currentUser = null;
    _authToken = null;
    _userHotspots.clear();
    _clearError();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    notifyListeners();
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Check if user is authenticated
  bool get isAuthenticated => _currentUser != null && _authToken != null;

  // Get user display name
  String get userDisplayName => _currentUser?.name ?? 'Mtumiaji';

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      _authToken = token;
      // Optionally validate token or fetch user profile
      notifyListeners();
    }
  }
}
