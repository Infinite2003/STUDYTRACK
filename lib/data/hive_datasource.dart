import 'package:hive_flutter/hive_flutter.dart';
import '../domain/task2.dart';


class HiveDatasource {
  static const String boxName = "tasksBox";

  Box get _box => Hive.box(boxName);

  Future<void> saveTask(Task2 task) async {
    await _box.put(task.id, task.toMap());
  }

  Future<List<Task2>> getAllTasks() async {
    return _box.values
        .map((e) => Task2.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  Future<void> updateTask(Task2 task) async {
    await _box.put(task.id, task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}