import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // En la versión 21.0.0, initialize requiere el parámetro nombrado 'settings'
    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'studytrack_channel',
      'StudyTrack Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // En la versión 21.0.0, show también usa parámetros nombrados
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'STUDYTRACK',
      body: 'Tarea guardada correctamente',
      notificationDetails: details,
    );
  }
}