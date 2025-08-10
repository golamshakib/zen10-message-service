import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling/routes/app_routes.dart';

import '../utils/logging/logger.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'userId';  // Add key for userId
  static const String _rememberMeKey = 'rememberMe'; // Key for "Remember Me" functionality

  static late SharedPreferences _preferences;
  static String? _token;
  static String? _userId;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(_tokenKey);
    _userId = _preferences.getString(_userIdKey);  // Initialize userId
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

  static Future<void> saveUserId(String userId) async {  // Save userId method
    try {
      await _preferences.setString(_userIdKey, userId);
      _userId = userId;
      AppLoggerHelper.info('User ID saved: $userId'); // Debug log
    } catch (e) {
      log('Error saving userId: $e');
    }
  }

  static Future<void> logoutUser() async {
    try {
      bool? rememberMe = _preferences.getBool('rememberMe');

      // If "Remember Me" is NOT enabled, clear email and password from SharedPreferences
      if (rememberMe != true) {
        await _preferences.remove('email');
        await _preferences.remove('password');
      }

      // Clear other auth-related data
      await _preferences.remove(_tokenKey);
      await _preferences.remove(_userIdKey);  // Clear userId

      // Reset the private variables
      _token = null;
      _userId = null;  // Clear userId as well
      await goToLogin();
    } catch (e) {
      log('Error during logout: $e');
    }
  }

  static Future<void> goToLogin() async {
    Get.offAllNamed(AppRoute.loginScreen);
  }

  static String? get token => _token;
  static String? get userId => _userId;  // Getter for userId
}
