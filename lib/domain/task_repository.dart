import '../domain/task2.dart';

abstract class TaskRepository {
  Future<void> saveTask(Task2 task);
}