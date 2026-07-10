import '../domain/task2.dart';

abstract class TaskRepository {
  Future<void> saveTask(Task2 task);
  Future<List<Task2>> getAllTasks();
  Stream<List<Task2>> watchAllTasks();
  Future<void> updateTask(Task2 task);
  Future<void> deleteTask(String id);
}
