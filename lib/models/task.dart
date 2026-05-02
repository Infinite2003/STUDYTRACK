class Task{
  
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String priority; 

  Task({

    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.priority
  });

  Task copyWith({

    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? priority
  }) {

    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority
    );
  }
}