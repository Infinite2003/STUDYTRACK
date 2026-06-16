import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../domain/task2.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {

    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: settings);

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
      await androidImpl.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleTaskNotification(Task2 task) async {
    final scheduledTime =
        task.dueDate.subtract(Duration(hours: task.reminderHours));

    if (scheduledTime.isBefore(DateTime.now())) {
      print('=== NOTIF: fecha ya pasó ===');
      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'studytrack_reminders',
      'Recordatorios de Tareas',
      channelDescription: 'Notificaciones de tareas próximas a vencer',
      importance: Importance.max,
      priority: Priority.high,
    );

    final int notifId = task.id.hashCode.abs() % 100000;

    final tz.TZDateTime tzScheduled = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    print('=== NOTIF: programando para $tzScheduled ===');

    try {
      await _plugin.zonedSchedule(
        id: notifId,
        title: '📚 Recordatorio: ${task.title}',
        body: 'Vence el ${_formatDate(task.dueDate)}',
        scheduledDate: tzScheduled,
        notificationDetails: const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print('=== NOTIF: zonedSchedule OK ===');
    } catch (e) {
      print('=== NOTIF ERROR: $e ===');
    }
  }
  Future<void> cancelTaskNotification(String taskId) async {
    final int notifId = taskId.hashCode.abs() % 100000;
    await _plugin.cancel(id: notifId);
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'studytrack_channel',
      'StudyTrack Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _plugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}