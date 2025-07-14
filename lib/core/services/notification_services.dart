import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static String? _fcmToken;
  static String? get fcmToken => _fcmToken;

  int _badgeCount = 0;
  RxInt unreadNotificationCount = 0.obs;  // Reactive variable to track unread count

  /// Initialize Push Notification Service
  Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("Notification permission status: ${settings.authorizationStatus}");

    // Set foreground presentation options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle iOS specific setup
    if (Platform.isIOS) {
      await _setupIOSNotifications();
    }

    // Get FCM Token
    _fcmToken = await _firebaseMessaging.getToken();
    log("FCM Token: $_fcmToken");

    // Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _fcmToken = token;
      log("FCM Token refreshed: $token");
    });

    // Initialize Local Notification Settings
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Notification clicked with payload: ${response.payload}");
        _handleNotificationTap(response.payload);
      },
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }

    // Handle Foreground Notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground message: ${message.notification?.title}");
      _showLocalNotification(message);
      unreadNotificationCount++;  // Increment unread notification count
    });

    // Handle Background Notification Tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Tapped notification while app was in background.");
      _handleFirebaseMessageTap(message);
    });

    // Handle Notification Tap From Terminated State
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log("Tapped notification from terminated state.");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleFirebaseMessageTap(message);
        });
      }
    });
  }

  /// Setup iOS specific notifications
  Future<void> _setupIOSNotifications() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      // Get APNS token
      String? apnsToken;
      int attempts = 0;
      const int maxAttempts = 10;

      do {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        await Future.delayed(const Duration(milliseconds: 300));
        attempts++;
      } while (apnsToken == null && attempts < maxAttempts);

      log("APNS Token: $apnsToken");
    }
  }

  /// Create Android notification channel
  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Show Local Notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    _badgeCount++;

    final notification = {
      "title": message.notification?.title ?? "No Title",
      "body": message.notification?.body ?? "No Body",
      "timestamp": DateTime.now().toIso8601String(),
      "data": message.data,
    };

    // Store to SharedPreferences
    await _storeNotification(notification);

    // Show system notification
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        badgeNumber: _badgeCount,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification['title'] as String,
      notification['body'] as String,
      details,
      payload: jsonEncode(notification),
    );
  }

  /// Store notification to SharedPreferences
  Future<void> _storeNotification(Map<String, dynamic> notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList('notifications') ?? [];
      existing.insert(0, jsonEncode(notification)); // latest on top

      // Keep only last 50 notifications
      if (existing.length > 50) {
        existing.removeRange(50, existing.length);
      }

      await prefs.setStringList('notifications', existing);
    } catch (e) {
      log("Error storing notification: $e");
    }
  }

  /// Handle local notification tap
  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      try {
        final data = jsonDecode(payload);
        // Navigate to your notification screen with data
        // Keep your existing navigation logic here
        _navigateToNotificationScreen(data);
      } catch (e) {
        log("Error parsing notification payload: $e");
        _navigateToNotificationScreen(null);
      }
    } else {
      _navigateToNotificationScreen(null);
    }
  }

  /// Handle Firebase message tap
  void _handleFirebaseMessageTap(RemoteMessage message) {
    final data = {
      "title": message.notification?.title,
      "body": message.notification?.body,
      "data": message.data,
    };
    _navigateToNotificationScreen(data);
  }

  /// Navigate to notification screen (keep your existing navigation logic)
  void _navigateToNotificationScreen(Map<String, dynamic>? data) {
    // TODO: Replace this with your actual navigation logic
    // Example:
    // navigatorKey.currentState?.push(
    //   MaterialPageRoute(
    //     builder: (context) => YourNotificationScreen(data: data),
    //   ),
    // );
    log("Navigating to notification screen with data: $data");
  }

  /// Clear notification badge (iOS)
  Future<void> clearBadge() async {
    _badgeCount = 0;
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin.show(
        0,
        null,
        null,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(badgeNumber: 0),
        ),
      );
    }
  }

  /// Get stored notifications
  Future<List<Map<String, dynamic>>> getStoredNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> notifications = prefs.getStringList('notifications') ?? [];
      return notifications.map((n) => jsonDecode(n) as Map<String, dynamic>).toList();
    } catch (e) {
      log("Error getting stored notifications: $e");
      return [];
    }
  }

  /// Clear all stored notifications
  Future<void> clearStoredNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notifications');
    } catch (e) {
      log("Error clearing stored notifications: $e");
    }
  }
}