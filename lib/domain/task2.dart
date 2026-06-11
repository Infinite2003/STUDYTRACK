class Task2 {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;
  final int reminderHours; // cuántas horas antes notificar

  Task2({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completed = false,
    this.reminderHours = 24,
  });

  Task2 copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    int? reminderHours,
  }) {
    return Task2(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      reminderHours: reminderHours ?? this.reminderHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'completed': completed,
      'reminderHours': reminderHours,
    };
  }

  factory Task2.fromMap(Map<String, dynamic> map) {
    return Task2(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      completed: map['completed'] as bool? ?? false,
      reminderHours: map['reminderHours'] as int? ?? 24,
    );
  }
}
