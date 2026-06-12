import '../domain/task2.dart';
import '../domain/task_repository.dart';
import 'hive_datasource.dart';
import 'notification_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final HiveDatasource hiveDatasource;
  final NotificationService notificationService;

  TaskRepositoryImpl({
    required this.hiveDatasource,
    required this.notificationService,
  });

  @override
  Future<void> saveTask(Task2 task) async {
    await hiveDatasource.saveTask(task);
    await notificationService.scheduleTaskNotification(task);
  }

  @override
  Future<List<Task2>> getAllTasks() async {
    return hiveDatasource.getAllTasks();
  }

  @override
  Future<void> updateTask(Task2 task) async {
    await hiveDatasource.updateTask(task);
    // Reprogramar notificación si se editó
    await notificationService.cancelTaskNotification(task.id);
    if (!task.completed) {
      await notificationService.scheduleTaskNotification(task);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await hiveDatasource.deleteTask(id);
    await notificationService.cancelTaskNotification(id);
  }
}
