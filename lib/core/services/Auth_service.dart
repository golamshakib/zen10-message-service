import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logging/logger.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static late SharedPreferences _preferences;
  static String? _token;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(_tokenKey);
    AppLoggerHelper.info('Token loaded: $_token');  // Debug log
  }

  static bool hasToken() {
    return _preferences.containsKey(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    try {
      await _preferences.setString(_tokenKey, token);
      _token = token;
      AppLoggerHelper.info('Token saved: $token'); // Debug log
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  static Future<void> logoutUser() async {
    try {
      await _preferences.clear();
      _token = null;
      await goToLogin();
    } catch (e) {
      log('Error during logout: $e');
    }
  }

  static Future<void> goToLogin() async {
    // Get.offAllNamed('/login');
  }

  static String? get token => _token;
}
