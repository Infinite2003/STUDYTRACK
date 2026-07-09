import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../domain/task2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

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

    await initFCM();
  }

  Future<void> initFCM() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    print('FCM TOKEN: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        showInstantNotification(
          title: notification.title ?? 'Notificación',
          body: notification.body ?? '',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        showInstantNotification(
          title: notification.title ?? 'Notificación',
          body: notification.body ?? '',
        );
      }
    });
  }

  Future<void> scheduleTaskNotification(Task2 task) async {
    final scheduledTime =
        task.dueDate.subtract(Duration(hours: task.reminderHours));

    if (scheduledTime.isBefore(DateTime.now())) {
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
    final tz.TZDateTime tzScheduled =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await _plugin.zonedSchedule(
      id: notifId,
      title: 'Recordatorio: ${task.title}',
      body: 'Vence el ${_formatDate(task.dueDate)}',
      scheduledDate: tzScheduled,
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
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

  Future<void> showCompletionNotification(Task2 task) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'studytrack_completed',
      'Tareas completadas',
      channelDescription: 'Notificaciones cuando una tarea se marca como hecha',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.show(
      id: task.id.hashCode.abs() % 100000,
      title: 'Tarea completada',
      body: '${task.title} ha sido marcada como hecha',
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
