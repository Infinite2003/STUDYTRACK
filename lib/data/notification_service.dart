import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../domain/task2.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
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
    }
  }

  Future<void> scheduleTaskNotification(Task2 task) async {
    final scheduledTime =
        task.dueDate.subtract(Duration(hours: task.reminderHours));

    if (scheduledTime.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'studytrack_reminders',
      'Recordatorios de Tareas',
      channelDescription: 'Notificaciones de tareas próximas a vencer',
      importance: Importance.max,
      priority: Priority.high,
    );

    final int notifId = task.id.hashCode.abs() % 100000;

    await _plugin.show(
      id: notifId,
      title: 'Recordatorio: ${task.title}',
      body: 'Vence el ${_formatDate(task.dueDate)}',
      notificationDetails: const NotificationDetails(android: androidDetails),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}