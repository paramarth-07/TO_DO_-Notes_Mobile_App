class Note {
  final int? id;
  final String title;
  final String content;
  final bool pinned;
  final DateTime? updatedAt;

  Note({
    this.id,
    required this.title,
    this.content = '',
    this.pinned = false,
    this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      pinned: json['pinned'] ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'pinned': pinned,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    bool? pinned,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
