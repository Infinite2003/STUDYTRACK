import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/task2.dart';
import '../domain/task_repository.dart';

class TaskRepositoryFirebase implements TaskRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> saveTask(Task2 task) async {
    await _db.collection('tasks').doc(task.id).set({
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate.toIso8601String(),
      'completed': task.completed,
      'reminderHours': task.reminderHours, 
    });
  }

  @override
  Future<List<Task2>> getAllTasks() async {
    final snapshot = await _db.collection('tasks').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Task2(
        id: data['id'] ?? doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        dueDate: DateTime.tryParse(data['dueDate'] ?? '') ?? DateTime.now(),
        completed: data['completed'] ?? false,
        reminderHours: data['reminderHours'] ?? 24, 
      );
    }).toList();
  }

  @override
  Future<void> updateTask(Task2 task) async {
    await _db.collection('tasks').doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate.toIso8601String(),
      'completed': task.completed,
      'reminderHours': task.reminderHours, 
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    await _db.collection('tasks').doc(id).delete();
  }
}
