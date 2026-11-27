import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String group; // 'today', 'yesterday', 'previous'
  final String category;
  final String title;
  final String description;
  final String time;
  final DateTime createdAt;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String? actionText;
  final String type; // 'pesanan', 'pembayaran', 'pengiriman', 'grooming', 'info'
  final int? orderId;
  final int? bookingId;
  bool isUnread;

  NotificationModel({
    required this.id,
    required this.group,
    required this.category,
    required this.title,
    required this.description,
    required this.time,
    required this.createdAt,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.actionText,
    this.type = 'pesanan',
    this.orderId,
    this.bookingId,
    this.isUnread = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'actionText': actionText,
      'type': type,
      'orderId': orderId,
      'bookingId': bookingId,
      'isUnread': isUnread,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())?.toLocal() ?? DateTime.now()
        : DateTime.now();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notifDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final diffDays = today.difference(notifDay).inDays;

    String group = 'previous';
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    String timeStr = '$hour:$minute WIB';

    if (diffDays == 0) {
      group = 'today';
    } else if (diffDays == 1) {
      group = 'yesterday';
      timeStr = 'Kemarin, $timeStr';
    } else {
      group = 'previous';
      timeStr = '$diffDays hari lalu';
    }

    final type = json['type']?.toString() ?? 'pesanan';
    IconData icon = Icons.notifications_outlined;
    Color iconBg = const Color(0xFFF5F5F5);
    Color iconColor = const Color(0xFF333333);

    switch (type) {
      case 'pesanan':
        icon = Icons.shopping_bag_outlined;
        iconBg = const Color(0xFFFCECEC);
        iconColor = const Color(0xFF850909);
        break;
      case 'pembayaran':
        icon = Icons.verified_outlined;
        iconBg = const Color(0xFFECFDF5);
        iconColor = const Color(0xFF22C55E);
        break;
      case 'pengiriman':
        icon = Icons.local_shipping_outlined;
        iconBg = const Color(0xFFEFF6FF);
        iconColor = const Color(0xFF3B82F6);
        break;
      case 'grooming':
        icon = Icons.pets;
        iconBg = const Color(0xFFFFDAD5);
        iconColor = const Color(0xFF850909);
        break;
      default:
        icon = Icons.notifications_active_outlined;
        iconBg = const Color(0xFFFCECEC);
        iconColor = const Color(0xFF850909);
        break;
    }

    return NotificationModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      group: group,
      category: json['category']?.toString() ?? 'Pesanan',
      title: json['title']?.toString() ?? 'Notifikasi',
      description: json['description']?.toString() ?? '',
      time: timeStr,
      createdAt: createdAt,
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      actionText: json['actionText']?.toString(),
      type: type,
      orderId: json['orderId'] != null ? int.tryParse(json['orderId'].toString()) : null,
      bookingId: json['bookingId'] != null ? int.tryParse(json['bookingId'].toString()) : null,
      isUnread: json['isUnread'] == true,
    );
  }
}
