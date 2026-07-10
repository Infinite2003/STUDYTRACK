import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/task2.dart';
import '../domain/create_task_usecase.dart';
import '../data/firestore_task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final CreateTaskUseCase createTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final FirestoreTaskRepository firestoreRepository;

  TaskViewModel({
    required this.createTaskUseCase,
    required this.getTasksUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.firestoreRepository,
  }) {
    loadTasks();
  }

  List<Task2> _tasks = [];
  bool isLoading = false;
  String? errorMessage;
  StreamSubscription<List<Task2>>? _subscription;

  List<Task2> get tasks => _tasks;
  List<Task2> get pendingTasks => _tasks.where((t) => !t.completed).toList();
  List<Task2> get completedTasks => _tasks.where((t) => t.completed).toList();

  List<Task2> get pendingTasks =>
      _tasks.where((t) => !t.completed).toList();

  List<Task2> get completedTasks =>
      _tasks.where((t) => t.completed).toList();

  List<Task2> sortedTasks(String sortBy) {
    final list = List<Task2>.from(_tasks);
    if (sortBy == 'date') {
      list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else {
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;
  }

  List<Task2> sortedPending(String sortBy) =>
      sortedTasks(sortBy).where((t) => !t.completed).toList();

  List<Task2> sortedCompleted(String sortBy) =>
      sortedTasks(sortBy).where((t) => t.completed).toList();

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

  void listenTasks(String uid) {
    _subscription?.cancel();
    _subscription = getTasksUseCase.watch(uid).listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  Future<bool> addTask(Task2 task) async {
    try {
      await createTaskUseCase.execute(task);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = 'Error al guardar: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> editTask(Task2 task) async {
    try {
      await updateTaskUseCase.execute(task);
      errorMessage = null;
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
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = 'Error al eliminar: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleComplete(Task2 task) async {
    try {
      final updated = task.copyWith(completed: !task.completed);
      await updateTaskUseCase.execute(updated);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = 'Error al actualizar: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
