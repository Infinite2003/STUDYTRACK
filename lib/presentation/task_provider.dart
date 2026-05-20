import 'package:flutter/material.dart';

import '../../domain/task2.dart';
import '../../domain/create_task_usecase.dart';

class TaskProvider extends ChangeNotifier {
  final CreateTaskUseCase createTaskUseCase;

  bool isLoading = false;

  String statusMessage = "Sin acciones";

  TaskProvider(this.createTaskUseCase);

  Future<void> createTask() async {
    isLoading = true;
    statusMessage = "Guardando tarea...";

    notifyListeners();

    try {
      final task = Task2(title: "Tarea PoC");

      await createTaskUseCase.execute(task);

      statusMessage = "Tarea guardada y notificación enviada";
    } catch (e) {
      statusMessage = "Error: $e";
    }

    isLoading = false;

    notifyListeners();
  }
}