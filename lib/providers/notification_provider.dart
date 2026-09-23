import 'package:flutter/foundation.dart';
import '../models/notification_item.dart';
import '../data/mock_notifications.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationItem> _notifications = [];

  NotificationProvider() {
    _notifications.addAll(MockNotifications.getInitialNotifications());
  }

  List<NotificationItem> get notifications => [..._notifications];
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
