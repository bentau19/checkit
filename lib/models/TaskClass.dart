final String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [
    /// Add all fields
    id, title, content, isEvent
  ];
  static final String id = '_id';
  static final String title = 'title';
  static final String content = 'content';
  static final String isEvent = 'isEvent';
}

class Task {
  dynamic id;
  String title;
  String content;
  bool isEvent;
  bool isSelected;

  Task({
    this.id,
    required this.title,
    this.content = "",
    required this.isEvent,
    this.isSelected = false,
  });
  Task copy({
    int? id,
    String? title,
    String? content,
    bool? isEvent,
  }) =>
      Task(
        id: id ?? this.id,
        isEvent: isEvent ?? this.isEvent,
        content: content ?? this.content,
        title: title ?? this.title,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int,
        isEvent: json[TaskFields.isEvent] == 1,
        title: json[TaskFields.title] as String,
        content: json[TaskFields.content] as String,
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.isEvent: isEvent ? 1 : 0,
        TaskFields.content: content,
      };
}
