import '../domain/task2.dart';
import '../domain/task_repository.dart';
import 'hive_datasource.dart';
import 'notification_service.dart';
import 'task_repository_firebase.dart';

class TaskRepositoryHybrid implements TaskRepository {
  final HiveDatasource hiveDatasource;
  final NotificationService notificationService;
  final TaskRepositoryFirebase firebaseRepo;

  TaskRepositoryHybrid({
    required this.hiveDatasource,
    required this.notificationService,
    required this.firebaseRepo,
  });

  @override
  Future<void> saveTask(Task2 task) async {
    await hiveDatasource.saveTask(task);
    await notificationService.scheduleTaskNotification(task);
    await firebaseRepo.saveTask(task); // sincroniza en Firebase
  }

  @override
  Future<List<Task2>> getAllTasks() async {
    final localTasks = await hiveDatasource.getAllTasks();
    final remoteTasks = await firebaseRepo.getAllTasks();
    // Puedes decidir si fusionar o priorizar remoto
    return remoteTasks.isNotEmpty ? remoteTasks : localTasks;
  }

  @override
  Future<void> updateTask(Task2 task) async {
    await hiveDatasource.updateTask(task);
    await notificationService.cancelTaskNotification(task.id);
    if (!task.completed) {
      await notificationService.scheduleTaskNotification(task);
    }
    await firebaseRepo.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await hiveDatasource.deleteTask(id);
    await notificationService.cancelTaskNotification(id);
    await firebaseRepo.deleteTask(id);
  }
}
