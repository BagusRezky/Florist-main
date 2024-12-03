import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int _notificationIdCounter = 0; // Counter untuk ID notifikasi

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel', // ID harus konsisten
      'Reminders', // Nama yang ditampilkan di settings
      description: 'Channel for flower care reminders',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        debugPrint('Notification clicked');
      },
    );

    // Request permissions at initialization
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      final bool? granted =
          await androidImplementation?.areNotificationsEnabled();
      debugPrint('Android notifications permission granted: $granted');
    }
  }

  int _generateNotificationId() {
    _notificationIdCounter++;
    return _notificationIdCounter;
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint('Next scheduled time: ${scheduledDate.toString()}');
    return scheduledDate;
  }

  Future<int> scheduleNotification({
    required String title,
    required String body,
    required TimeOfDay scheduledTime,
    required String status,
  }) async {
    try {
      // Generate unique ID for this notification set
      final baseId = _generateNotificationId();
      debugPrint('Scheduling notification with base ID: $baseId');

      // Basic notification details
      final androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Channel for flower care reminders',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        category: AndroidNotificationCategory.reminder,
        autoCancel: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        baseId,
        title,
        body,
        
        notificationDetails,
      );

      // Schedule the first notification
      final firstTime = _nextInstanceOfTime(scheduledTime);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        baseId,
        title,
        body,
        firstTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint(
          'First notification scheduled for $firstTime with ID: $baseId');

      // For recurring notifications based on status
      int daysToAdd;
      switch (status.toLowerCase()) {
        case 'harian':
          daysToAdd = 1;
          break;
        case '3 hari':
          daysToAdd = 3;
          break;
        case '1 minggu':
          daysToAdd = 7;
          break;
        default:
          daysToAdd = 1;
      }

      // Schedule additional notifications for the next few occurrences
      for (int i = 1; i < 5; i++) {
        final nextTime = firstTime.add(Duration(days: daysToAdd * i));
        final nextId = baseId + i;

        await flutterLocalNotificationsPlugin.zonedSchedule(
          nextId,
          title,
          body,
          nextTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );

        debugPrint(
            'Additional notification scheduled for $nextTime with ID: $nextId');
      }

      // Return the base ID for future reference
      return baseId;
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      rethrow;
    }
  }

  Future<void> cancelNotification(int id) async {
    // Cancel the base notification and the next 4 recurring notifications
    for (int i = 0; i < 5; i++) {
      await flutterLocalNotificationsPlugin.cancel(id + i);
    }
    debugPrint('Cancelled notifications with IDs: $id to ${id + 4}');
  }

  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for flower care reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Use 0 for test notifications
      'Test Notification',
      'This is a test notification',
      notificationDetails,
    );
  }
}
