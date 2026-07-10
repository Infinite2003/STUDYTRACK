import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../data/notification_service.dart';

const String taskReminderTaskName = "check_task_reminders";

/// Punto de entrada del isolate de background. workmanager lo ejecuta
/// como una función top-level independiente del árbol de widgets de la
/// app — por eso hay que re-inicializar Flutter binding y Firebase
/// aquí, aunque ya estén inicializados en el main() normal.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final notificationService = NotificationService();
      await notificationService.init();
      await notificationService.checkAndNotifyDueTasks();

      return Future.value(true);
    } catch (e) {
      // Si algo falla, se devuelve false para que WorkManager reintente
      // en su próximo ciclo en vez de perder el chequeo silenciosamente.
      return Future.value(false);
    }
  });
}

/// Registra la tarea periódica. Llamar UNA vez desde main(), después de
/// Workmanager().initialize(callbackDispatcher).
Future<void> registerTaskReminderJob() async {
  await Workmanager().registerPeriodicTask(
    taskReminderTaskName,
    taskReminderTaskName,
    frequency: const Duration(minutes: 15), // mínimo permitido por Android
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}