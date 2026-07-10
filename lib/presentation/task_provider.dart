import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/task2.dart';
import '../../domain/create_task_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskProvider extends ChangeNotifier {
  final CreateTaskUseCase createTaskUseCase;

  bool isLoading = false;
  String statusMessage = "Sin acciones";

  TaskProvider(this.createTaskUseCase);

  Future<void> createTask() async {
    isLoading = true;
    statusMessage = "Guardando tarea...";
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final task = Task2(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Tarea PoC",
        description: "Descripción de prueba",
        dueDate: DateTime.now().add(const Duration(days: 1)),
        userId: uid,
      );

      await createTaskUseCase.execute(task);
      statusMessage = "Tarea guardada y notificación enviada";
    } catch (e) {
      statusMessage = "Error: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
