class Task2 {

  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;

  Task2({

    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completed = false,
  });
}