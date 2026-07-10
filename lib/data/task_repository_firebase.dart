import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../domain/task2.dart';
import '../domain/task_repository.dart';

class TaskRepositoryFirebase implements TaskRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  CollectionReference<Map<String, dynamic>> get _tasksRef =>
      _db.collection('tasks');

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

  Task2 _fromDoc(Map<String, dynamic> data, String docId) {
    final userId = data['userId'] as String;
    return Task2(
      id: data['id'] ?? docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: DateTime.tryParse(data['dueDate'] ?? '') ?? DateTime.now(),
      completed: data['completed'] ?? false,
      reminderHours: data['reminderHours'] ?? 24,
      userId: userId,
      members: (data['members'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [userId],
      notifiedMembers: (data['notifiedMembers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  Future<void> saveTask(Task2 task) async {
    final uid = _auth.currentUser!.uid;
    await _saveUserToken();
    await _tasksRef.doc(task.id).set({
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate.toIso8601String(),
      'completed': task.completed,
      'reminderHours': task.reminderHours,
      'userId': uid,
      'members': [uid],
      'notifiedMembers': <String>[],
    });
  }

  @override
  Future<List<Task2>> getAllTasks() async {
    final uid = _auth.currentUser!.uid;
    final snapshot =
        await _tasksRef.where('members', arrayContains: uid).get();
    return snapshot.docs.map((doc) => _fromDoc(doc.data(), doc.id)).toList();
  }

  @override
  Stream<List<Task2>> watchAllTasks() {
    final uid = _auth.currentUser!.uid;
    return _tasksRef
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _fromDoc(doc.data(), doc.id)).toList());
  }

  Stream<List<Task2>> watchTasks(String uid) {
    return _tasksRef
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _fromDoc(doc.data(), doc.id)).toList());
  }

  /// Tareas activas donde el uid dado es miembro. Pensada para el chequeo
  /// periódico en segundo plano (workmanager): trae todo lo relevante en
  /// una sola consulta; el filtrado de "¿ya toca notificar?" se hace en
  /// Dart, porque reminderHours varía por tarea y Firestore no puede
  /// calcular esa resta en la query.
  Future<List<Task2>> getActiveTasksForMember(String uid) async {
    final snapshot = await _tasksRef
        .where('members', arrayContains: uid)
        .where('completed', isEqualTo: false)
        .get();
    return snapshot.docs.map((doc) => _fromDoc(doc.data(), doc.id)).toList();
  }

  /// Marca que a este uid YA se le notificó esta tarea. Cada dispositivo
  /// solo agrega su propio uid, nunca toca las entradas de otros miembros.
  Future<void> markNotified(String taskId, String uid) async {
    await _tasksRef.doc(taskId).update({
      'notifiedMembers': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> shareTask(String taskId, String targetUid) async {
    await _tasksRef.doc(taskId).update({
      'members': FieldValue.arrayUnion([targetUid]),
    });
  }

  Future<void> unshareTask(
      String taskId, String targetUid, String ownerUid) async {
    if (targetUid == ownerUid) {
      throw Exception('No se puede quitar al dueño de la tarea.');
    }
    await _tasksRef.doc(taskId).update({
      'members': FieldValue.arrayRemove([targetUid]),
      'notifiedMembers': FieldValue.arrayRemove([targetUid]),
    });
  }

  @override
  Future<void> updateTask(Task2 task) async {
    final docRef = _tasksRef.doc(task.id);

    final snapshot = await docRef.get();
    final previousDueDate = snapshot.data()?['dueDate'] as String?;
    final dueDateChanged = previousDueDate != task.dueDate.toIso8601String();

    await docRef.update({
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate.toIso8601String(),
      'completed': task.completed,
      'reminderHours': task.reminderHours,
      // si cambió la fecha, todos vuelven a ser elegibles para notificación
      'notifiedMembers': dueDateChanged ? <String>[] : task.notifiedMembers,
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }
}