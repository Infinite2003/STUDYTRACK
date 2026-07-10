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

  /// Comparte la tarea agregando al uid destino en "members", en la MISMA
  /// tarea de la colección raíz — no crea una copia en otra subcolección.
  /// ownerUserId se mantiene en la firma por compatibilidad con quien ya
  /// llama a este método, pero ya no se usa para armar la ruta.
  Future<void> shareTaskWithUser(
      String taskId, String ownerUserId, String targetUserId) async {
    await _tasks.doc(taskId).update({
      'members': FieldValue.arrayUnion([targetUserId]),
    });
  }

  Future<void> removeUserFromTask(
      String taskId, String ownerUserId, String targetUserId) async {
    await _tasks.doc(taskId).update({
      'members': FieldValue.arrayRemove([targetUserId]),
      'notifiedMembers': FieldValue.arrayRemove([targetUserId]),
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

  /// Tareas compartidas con el usuario. Como TODAS las tareas viven en la
  /// colección raíz "tasks" (no hay subcolecciones por usuario), no hace
  /// falta collectionGroup — una query normal con arrayContains basta y
  /// evita pedir un índice de collection group innecesario.
  Stream<List<Task2>> sharedTasksStream(String userId) {
    return _tasks
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task2.fromMap(doc.data() as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate)));
  }
}