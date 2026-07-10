import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/task2.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreTaskRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _tasks => _db.collection('tasks');

  Future<void> saveTask(Task2 task) async {
    await _tasks.doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(Task2 task) async {
    await _tasks.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }

  Stream<List<Task2>> tasksStream(String userId) {
    return _tasks
        .where('members', arrayContains: userId)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task2.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> shareTaskWithUser(
      String taskId, String ownerUserId, String targetUserId) async {
    await _db
        .collection('users')
        .doc(ownerUserId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'members': FieldValue.arrayUnion([targetUserId]),
    });
  }

  Future<void> removeUserFromTask(
      String taskId, String ownerUserId, String targetUserId) async {
    await _db
        .collection('users')
        .doc(ownerUserId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'members': FieldValue.arrayRemove([targetUserId]),
    });
  }

  Future<String?> findUserIdByEmail(String email) async {
    print('=== Buscando usuario con email: $email ===');
    final snapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    print('=== Documentos encontrados: ${snapshot.docs.length} ===');
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  }

   // Stream de tareas compartidas con el usuario
  // Lee desde todas las subcolecciones donde el usuario es miembro
  Stream<List<Task2>> sharedTasksStream(String userId) {
    return _db
        .collectionGroup('tasks')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Task2.fromMap(doc.data()))
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate)));
  }

}