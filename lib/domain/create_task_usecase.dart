import '../domain/task2.dart';
import '../domain/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<void> execute(Task2 task) async {
    await repository.saveTask(task);
  }
}