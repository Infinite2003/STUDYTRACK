import '../domain/task2.dart';
import '../domain/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<void> execute(Task2 task) async => repository.saveTask(task);
}

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<Task2>> execute() async => repository.getAllTasks();

  Stream<List<Task2>> watch(String uid) => repository.watchAllTasks();
}

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> execute(Task2 task) async => repository.updateTask(task);
}

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> execute(String id) async => repository.deleteTask(id);
}
