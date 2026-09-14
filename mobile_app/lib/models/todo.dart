class Todo {
  final int? id;
  final String title;
  final bool completed;
  final String priority;
  final DateTime? createdAt;

  Todo({
    this.id,
    required this.title,
    this.completed = false,
    this.priority = 'MEDIUM',
    this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
      priority: json['priority'] ?? 'MEDIUM',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'completed': completed,
      'priority': priority,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
    String? priority,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
