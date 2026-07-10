class Task2 {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;
  final int reminderHours;
  final String userId; // uid del dueño (inmutable)
  final List<String> members; // dueño + usuarios con quienes se compartió
  final List<String> notifiedMembers; // uids a quienes YA se les notificó

  Task2({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completed = false,
    this.reminderHours = 24,
    required this.userId,
    List<String>? members,
    this.notifiedMembers = const [],
  }) : members = members ?? [userId];

  List<String> get sharedWith =>
      members.where((uid) => uid != userId).toList();

  bool isOwner(String uid) => uid == userId;

  bool wasNotified(String uid) => notifiedMembers.contains(uid);

  DateTime get reminderTime =>
      dueDate.subtract(Duration(hours: reminderHours));

  bool isReminderDue(DateTime now) => !reminderTime.isAfter(now);

  Task2 copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    int? reminderHours,
    String? userId,
    List<String>? members,
    List<String>? notifiedMembers,
  }) {
    return Task2(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      reminderHours: reminderHours ?? this.reminderHours,
      userId: userId ?? this.userId,
      members: members ?? this.members,
      notifiedMembers: notifiedMembers ?? this.notifiedMembers,
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
      'userId': userId,
      'members': members,
      'notifiedMembers': notifiedMembers,
    };
  }

  factory Task2.fromMap(Map<String, dynamic> map) {
    final userId = map['userId'] as String;
    return Task2(
      id: map['id'] as String,
      title: map['title'] as String? ?? 'Sin título',
      description: map['description'] as String? ?? '',
      dueDate: DateTime.parse(map['dueDate'] as String),
      completed: map['completed'] as bool? ?? false,
      reminderHours: map['reminderHours'] as int? ?? 24,
      userId: userId,
      members: (map['members'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [userId],
      notifiedMembers: (map['notifiedMembers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}