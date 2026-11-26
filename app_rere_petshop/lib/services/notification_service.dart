import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_rere_petshop/models/notification_model.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final AuthService _authService = AuthService();
  bool _isInitialized = false;

  static const String channelId = 'rere_petshop_orders_channel';
  static const String channelName = 'Notifikasi Pesanan ReRe Petshop';
  static const String channelDesc =
      'Notifikasi status pesanan, pembayaran, dan booking ReRe Petshop';

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    try {
      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked with payload: ${response.payload}');
        },
      );

      // Create high-importance Android notification channel
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            description: channelDesc,
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );

        // Minta izin notifikasi (Android 13+)
        await androidImplementation.requestNotificationsPermission();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing local notifications: $e');
    }
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) return;

    if (!_isInitialized) {
      await init();
    }

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/launcher_icon',
      color: Color(0xFF850909),
      playSound: true,
      enableVibration: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      await _localNotifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  Future<String> _getStorageKey({String? userKey}) async {
    if (userKey != null && userKey.trim().isNotEmpty) {
      return 'user_notifications_${userKey.trim()}';
    }
    final key = await _authService.getCurrentUserKey();
    return 'user_notifications_$key';
  }

  Future<List<NotificationModel>> getNotifications({String? userKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = await _getStorageKey(userKey: userKey);
    final rawList = prefs.getStringList(storageKey) ?? [];

    return rawList
        .map((item) {
          try {
            final map = jsonDecode(item) as Map<String, dynamic>;
            return NotificationModel.fromJson(map);
          } catch (_) {
            return null;
          }
        })
        .whereType<NotificationModel>()
        .toList();
  }

  Future<void> addNotification({
    required String title,
    required String description,
    required String category,
    String type = 'pesanan',
    String? actionText,
    int? orderId,
    int? bookingId,
    String? userKey,
    bool showSystemNotification = true,
  }) async {
    final now = DateTime.now();
    final notifId = now.millisecondsSinceEpoch;

    final model = NotificationModel(
      id: notifId.toString(),
      group: 'today',
      category: category,
      title: title,
      description: description,
      time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB',
      createdAt: now,
      icon: Icons.notifications,
      iconBg: const Color(0xFFFCECEC),
      iconColor: const Color(0xFF850909),
      actionText: actionText,
      type: type,
      orderId: orderId,
      bookingId: bookingId,
      isUnread: true,
    );

    final prefs = await SharedPreferences.getInstance();
    final storageKey = await _getStorageKey(userKey: userKey);
    final currentList = prefs.getStringList(storageKey) ?? [];

    currentList.insert(0, jsonEncode(model.toJson()));
    await prefs.setStringList(storageKey, currentList);

    if (showSystemNotification) {
      final notifIntId = (notifId % 100000000);
      await showLocalNotification(
        id: notifIntId,
        title: title,
        body: description,
        payload: jsonEncode({
          'orderId': orderId,
          'bookingId': bookingId,
          'type': type,
        }),
      );
    }
  }

  Future<void> markAsRead(String notifId, {String? userKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = await _getStorageKey(userKey: userKey);
    final rawList = prefs.getStringList(storageKey) ?? [];

    final updated = rawList.map((item) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        if (map['id']?.toString() == notifId) {
          map['isUnread'] = false;
        }
        return jsonEncode(map);
      } catch (_) {
        return item;
      }
    }).toList();

    await prefs.setStringList(storageKey, updated);
  }

  Future<void> markAllAsRead({String? userKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = await _getStorageKey(userKey: userKey);
    final rawList = prefs.getStringList(storageKey) ?? [];

    final updated = rawList.map((item) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        map['isUnread'] = false;
        return jsonEncode(map);
      } catch (_) {
        return item;
      }
    }).toList();

    await prefs.setStringList(storageKey, updated);
  }

  Future<void> clearAll({String? userKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = await _getStorageKey(userKey: userKey);
    await prefs.remove(storageKey);
  }
}
