import '../domain/task2.dart';
import '../domain/task_repository.dart';
import '../data/hive_datasource.dart';
import '../data/notification_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final HiveDatasource hiveDatasource;
  final NotificationService notificationService;

  TaskRepositoryImpl({
    required this.hiveDatasource,
    required this.notificationService,
  });

  @override
  Future<void> saveTask(Task2 task) async {
    await hiveDatasource.saveTask(task.title);

    await notificationService.showNotification();
  }
}