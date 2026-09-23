import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../core/constants/app_colors.dart';

class MockNotifications {
  static List<NotificationItem> getInitialNotifications() {
    return [
      NotificationItem(
        id: 'notif-1',
        title: 'You saved ₹120 today!',
        message: 'Your smart BlinkCart savings have been credited to your monthly summary.',
        timeAgo: '10 mins ago',
        icon: Icons.savings_rounded,
        iconColor: AppColors.success,
      ),
      NotificationItem(
        id: 'notif-2',
        title: 'Order Arriving Soon',
        message: 'Your rider Rahul is 2 minutes away from your location in Kharghar.',
        timeAgo: '25 mins ago',
        icon: Icons.delivery_dining_rounded,
        iconColor: AppColors.primary,
      ),
      NotificationItem(
        id: 'notif-3',
        title: 'Flash Sale starts in 30 minutes!',
        message: 'Get up to 60% off on fresh dairy, snacks and household essentials.',
        timeAgo: '1 hour ago',
        icon: Icons.bolt_rounded,
        iconColor: AppColors.accent,
      ),
      NotificationItem(
        id: 'notif-4',
        title: 'Your favorite milk is back in stock',
        message: 'Amul Taaza Milk 1L is freshly restocked at your local dark store.',
        timeAgo: '3 hours ago',
        icon: Icons.inventory_2_rounded,
        iconColor: AppColors.primaryLight,
      ),
      NotificationItem(
        id: 'notif-5',
        title: 'You unlocked a new coupon: FIRST100',
        message: 'Use code FIRST100 to get flat ₹100 OFF on your next order.',
        timeAgo: '1 day ago',
        icon: Icons.card_giftcard_rounded,
        iconColor: AppColors.accent,
      ),
    ];
  }
}
