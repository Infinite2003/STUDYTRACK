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
        String taskId,
        String targetUserId,
    ) async {
      final currentUid = FirebaseAuth.instance.currentUser!.uid;

      // Documento de la tarea del usuario actual
      final sourceDoc = await _db
          .collection('users')
          .doc(currentUid)
          .collection('tasks')
          .doc(taskId)
          .get();

      if (!sourceDoc.exists) {
        throw Exception('La tarea no existe');
      }

      final data = sourceDoc.data()!;

      // Actualizar members
      final members = List<String>.from(data['members'] ?? []);

      if (!members.contains(targetUserId)) {
        members.add(targetUserId);
      }

      data['members'] = members;

      // Actualizar la copia del dueño
      await sourceDoc.reference.update({
        'members': members,
      });

      // Crear la copia para el usuario compartido
      await _db
          .collection('users')
          .doc(targetUserId)
          .collection('tasks')
          .doc(taskId)
          .set(data);
    }

  Future<void> removeUserFromTask(String taskId, String targetUserId) async {
    await _tasks.doc(taskId).update({
      'members': FieldValue.arrayRemove([targetUserId]),
    });
  }

  Future<String?> findUserIdByEmail(String email) async {
    final snapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  }
}