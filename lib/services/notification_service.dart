// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/transaction.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleTransactionReminder(Transaction transaction) async {
    if (!transaction.isRecurring || transaction.nextDueDate == null) return;

    final transactionDate = transaction.nextDueDate!;

    // Schedule a notification 1 day before the transaction is due
    final scheduledDate = transactionDate.subtract(const Duration(days: 1));

    if (scheduledDate.isBefore(DateTime.now())) return;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      transaction.id.hashCode,
      'Payment Reminder',
      'Your ${transaction.title} payment of ${transaction.amount} is due tomorrow',
      _nextInstanceOfTime(scheduledDate),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'payment_reminder_channel',
          'Payment Reminders',
          channelDescription: 'Notifications for upcoming payments',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  TZDateTime _nextInstanceOfTime(DateTime scheduledDate) {
    final now = DateTime.now();
    return TZDateTime.from(scheduledDate, _tzi);
  }

  // You'll need to implement this getter to return your timezone
  static get _tzi => local;
}