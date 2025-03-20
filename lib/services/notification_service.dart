import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import '../models/transaction.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize timezone data
    tzdata.initializeTimeZones();

    // Use a more reliable timezone for your local area
    // You can get the local timezone using package:flutter_native_timezone
    // For now, using a more common default
    tz.setLocalLocation(tz.getLocation('America/New_York')); // Change to your timezone

    // Initialize Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize iOS settings
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine platform settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification taps here if needed
        print('Notification clicked: ${response.payload}');
      },
    );

    // Request permission on iOS (Not required for Android)
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> scheduleTransactionReminder(Transaction transaction) async {
    if (!transaction.isRecurring ||
        !transaction.enableNotification ||
        transaction.nextDueDate == null) {
      return;
    }

    final transactionDate = transaction.nextDueDate!;

    // Schedule a notification 1 day before the transaction is due
    final notificationDate = transactionDate.subtract(const Duration(days: 1));

    if (notificationDate.isBefore(DateTime.now())) return;

    try {
      // Create a DateTime with the notification date and user's preferred time
      final scheduledDateTime = DateTime(
        notificationDate.year,
        notificationDate.month,
        notificationDate.day,
        transaction.notificationTime?.hour ?? 9, // Default to 9 AM if not specified
        transaction.notificationTime?.minute ?? 0,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        transaction.id.hashCode,
        'Payment Reminder',
        'Your ${transaction.title} payment of \$${transaction.amount} is due tomorrow',
        _nextInstanceOfTime(scheduledDateTime),
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
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime scheduledDate) {
    final location = tz.local; // Use the local timezone we set in initialize()
    return tz.TZDateTime.from(scheduledDate, location);
  }
}