import '../domain/task2.dart';
import '../domain/task_repository.dart';
import 'hive_datasource.dart';
import 'notification_service.dart';
import 'task_repository_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskRepositoryHybrid implements TaskRepository {
  final HiveDatasource hiveDatasource;
  final NotificationService notificationService;
  final TaskRepositoryFirebase firebaseRepo;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TaskRepositoryHybrid({
    required this.hiveDatasource,
    required this.notificationService,
    required this.firebaseRepo,
  });

  @override
  Future<void> saveTask(Task2 task) async {
    final uid = _auth.currentUser!.uid;
    final taskWithUser = task.copyWith(userId: uid);
    await hiveDatasource.saveTask(taskWithUser);
    await firebaseRepo.saveTask(taskWithUser);
    await notificationService.scheduleTaskNotification(taskWithUser);
  }

  @override
  Future<List<Task2>> getAllTasks() async {
    final localTasks = await hiveDatasource.getAllTasks();
    final remoteTasks = await firebaseRepo.getAllTasks();
    return remoteTasks.isNotEmpty ? remoteTasks : localTasks;
  }

  @override
  Future<void> updateTask(Task2 task) async {
    final uid = _auth.currentUser!.uid;
    final taskWithUser = task.copyWith(userId: uid);
    await hiveDatasource.updateTask(taskWithUser);
    await firebaseRepo.updateTask(taskWithUser);

    await notificationService.cancelTaskNotification(task.id);
    if (taskWithUser.completed) {
      await notificationService.showCompletionNotification(taskWithUser);
    } else {
      await notificationService.scheduleTaskNotification(taskWithUser);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await hiveDatasource.deleteTask(id);
    await firebaseRepo.deleteTask(id);
    await notificationService.cancelTaskNotification(id);
  }
}
