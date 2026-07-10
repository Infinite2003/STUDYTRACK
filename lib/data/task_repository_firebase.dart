import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../domain/task2.dart';
import '../domain/task_repository.dart';

class TaskRepositoryFirebase implements TaskRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> _saveUserToken() async {
    final uid = _auth.currentUser!.uid;
    final token = await _messaging.getToken();
    if (token != null) {
      await _db
          .collection('userTokens')
          .doc(uid)
          .collection('tokens')
          .doc(token)
          .set({'createdAt': DateTime.now().toIso8601String()});
    }
  }

  @override
  Future<void> saveTask(Task2 task) async {
    final uid = _auth.currentUser!.uid;
    await _saveUserToken();
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .set({
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'members': task.members,
          'dueDate': task.dueDate.toIso8601String(),
          'completed': task.completed,
          'reminderHours': task.reminderHours,
          'userId': uid,
        });
  }

  @override
  Future<List<Task2>> getAllTasks() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Task2(
        id: data['id'] ?? doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        members: List<String>.from(data['members'] ?? [uid]),
        dueDate: DateTime.tryParse(data['dueDate'] ?? '') ?? DateTime.now(),
        completed: data['completed'] ?? false,
        reminderHours: data['reminderHours'] ?? 24,
        userId: uid,
      );
    }).toList();
  }

  Stream<List<Task2>> watchTasks(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Task2(
                id: data['id'] ?? doc.id,
                members: List<String>.from(data['members'] ?? [uid]),
                title: data['title'] ?? '',
                description: data['description'] ?? '',
                dueDate:
                    DateTime.tryParse(data['dueDate'] ?? '') ?? DateTime.now(),
                completed: data['completed'] ?? false,
                reminderHours: data['reminderHours'] ?? 24,
                userId: uid,
              );
            }).toList());
  }
  @override
Stream<List<Task2>> watchAllTasks() {
  final uid = _auth.currentUser!.uid;
  return _db
      .collection('users')
      .doc(uid)
      .collection('tasks')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Task2(
              id: data['id'] ?? doc.id,
              members: List<String>.from(data['members'] ?? [uid]),
              title: data['title'] ?? '',
              description: data['description'] ?? '',
              dueDate:
                  DateTime.tryParse(data['dueDate'] ?? '') ?? DateTime.now(),
              completed: data['completed'] ?? false,
              reminderHours: data['reminderHours'] ?? 24,
              userId: uid,
              
            );
          }).toList());
}


  @override
  Future<void> updateTask(Task2 task) async {
    await _db
        .collection('users')
        .doc(task.userId)
        .collection('tasks')
        .doc(task.id)
        .update({
          'title': task.title,
          'description': task.description,
          'dueDate': task.dueDate.toIso8601String(),
          'completed': task.completed,
          'reminderHours': task.reminderHours,
        });
  }

  @override
  Future<void> deleteTask(String id) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(id)
        .delete();
  }
}
