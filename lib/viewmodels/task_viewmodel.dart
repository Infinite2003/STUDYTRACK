import 'package:flutter/material.dart';
import '../domain/task2.dart';
import '../domain/create_task_usecase.dart';

class TaskViewModel extends ChangeNotifier {
  final CreateTaskUseCase createTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskViewModel({
    required this.createTaskUseCase,
    required this.getTasksUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) {
    loadTasks();
  }

  List<Task2> _tasks = [];
  bool isLoading = false;
  String? errorMessage;

  List<Task2> get tasks => _tasks;

  List<Task2> get pendingTasks =>
      _tasks.where((t) => !t.completed).toList();

  List<Task2> get completedTasks =>
      _tasks.where((t) => t.completed).toList();

  /// Retorna tareas del día dado para el calendario
  List<Task2> tasksForDay(DateTime day) {
    return _tasks.where((t) {
      return t.dueDate.year == day.year &&
          t.dueDate.month == day.month &&
          t.dueDate.day == day.day;
    }).toList();
  }

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();
    try {
      _tasks = await getTasksUseCase.execute();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error cargando tareas: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> addTask(Task2 task) async {
    try {
      await createTaskUseCase.execute(task);
      await loadTasks();
      return true;
    } catch (e) {
      errorMessage = 'Error al guardar: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleComplete(Task2 task) async {
    try {
      final updated = task.copyWith(completed: !task.completed);
      await updateTaskUseCase.execute(updated);
      await loadTasks();
      return true;
    } catch (e) {
      errorMessage = 'Error al actualizar: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> editTask(Task2 task) async {
    try {
      await updateTaskUseCase.execute(task);
      await loadTasks();
      return true;
    } catch (e) {
      errorMessage = 'Error al editar: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await deleteTaskUseCase.execute(id);
      await loadTasks();
      return true;
    } catch (e) {
      errorMessage = 'Error al eliminar: $e';
      notifyListeners();
      return false;
    }
  }
}