import 'package:flutter/material.dart';

class NotificationManager {
  static final ValueNotifier<List<NotificationData>> _notifications = ValueNotifier([]);

  static ValueNotifier<List<NotificationData>> get notifications => _notifications;

  static void addNotification(String title, String description) {
    _notifications.value = [
      NotificationData(title: title, description: description),
      ..._notifications.value,
    ];
  }

  static void clear() {
    _notifications.value = [];
  }
}

class NotificationData {
  final String title;
  final String description;

  NotificationData({required this.title, required this.description});
}
