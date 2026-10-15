class HomeTask {
  final int id;
  final String title;
  final DateTime? reminder;
  final bool done;

  HomeTask({
    required this.id,
    required this.title,
    this.reminder,
    this.done = false,
  });

  HomeTask copyWith({DateTime? reminder, bool? done}) => HomeTask(
        id: id,
        title: title,
        reminder: reminder ?? this.reminder,
        done: done ?? this.done,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'reminder': reminder?.toIso8601String(),
        'done': done,
      };

  factory HomeTask.fromJson(Map<String, dynamic> json) => HomeTask(
        id: json['id'] as int,
        title: json['title'] as String,
        reminder: json['reminder'] == null
            ? null
            : DateTime.parse(json['reminder'] as String),
        done: json['done'] == true,
      );
}
