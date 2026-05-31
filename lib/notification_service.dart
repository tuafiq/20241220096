import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );

    // Request permissions for Android 13+
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
        
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  Future<void> scheduleDailyNotification(int id, String title, String body, TimeOfDay time) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(time),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel',
          'Daily Notifications',
          channelDescription: 'Channel for daily prayer reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleAdzan(int id, String title, String body, DateTime time, String soundType) async {
    // Determine the raw sound filename without extension
    String soundFileName = '';
    String channelId = 'adzan_channel_default';
    String channelName = 'Adzan Default';
    
    if (soundType.toLowerCase().contains('makkah')) {
      soundFileName = 'makkah';
      channelId = 'adzan_channel_makkah';
      channelName = 'Adzan Makkah';
    } else if (soundType.toLowerCase().contains('madinah')) {
      soundFileName = 'madinah';
      channelId = 'adzan_channel_madinah';
      channelName = 'Adzan Madinah';
    } else if (soundType.toLowerCase().contains('aqsa')) {
      soundFileName = 'alaqsa';
      channelId = 'adzan_channel_alaqsa';
      channelName = 'Adzan Al-Aqsa';
    } else if (soundType.toLowerCase().contains('indonesia')) {
      soundFileName = 'indonesia';
      channelId = 'adzan_channel_indonesia';
      channelName = 'Adzan Indonesia';
    }

    AndroidNotificationDetails androidPlatformChannelSpecifics;
    
    if (soundFileName.isNotEmpty) {
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'Pemberitahuan Waktu Sholat',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(soundFileName),
        playSound: true,
      );
    } else {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'adzan_channel_default',
        'Adzan Default',
        channelDescription: 'Pemberitahuan Waktu Sholat Default',
        importance: Importance.max,
        priority: Priority.high,
      );
    }

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(time, tz.local);
    
    // Only schedule if time is in the future
    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }
  
  Future<void> cancelAllAdzans() async {
    // Adzan IDs are reserved from 1000 to 2000
    for (int i = 1000; i <= 2000; i++) {
      await cancelNotification(i);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, time.hour, time.minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
