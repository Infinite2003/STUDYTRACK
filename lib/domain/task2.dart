class Task2 {
  final String id;
  final String ownerUserId;        // quien creó la tarea
  final List<String> members;      // todos los que pueden verla y editarla
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;
  final int reminderHours;

  Task2({
    required this.id,
    required this.ownerUserId,
    required this.members,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completed = false,
    this.reminderHours = 24,
  });

  Task2 copyWith({
    String? id,
    String? ownerUserId,
    List<String>? members,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    int? reminderHours,
  }) {
    return Task2(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      members: members ?? this.members,
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
      'ownerUserId': ownerUserId,
      'members': members,
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
      ownerUserId: map['ownerUserId'] as String? ?? '',
      members: List<String>.from(map['members'] as List? ?? []),
      title: map['title'] as String? ?? 'Sin título',
      description: map['description'] as String? ?? '',
      dueDate: DateTime.parse(map['dueDate'] as String),
      completed: map['completed'] as bool? ?? false,
      reminderHours: map['reminderHours'] as int? ?? 24,
    );
  }
}