class ClassTodo {
  final String title;
  final DateTime time;

  ClassTodo({required this.title, required this.time});

  String toLine() => '$title|${time.toIso8601String()}';

  factory ClassTodo.fromLine(String line) {
    final parts = line.split('|');
    if (parts.length != 2) {
      throw const FormatException('Du lieu todo.txt khong hop le');
    }
    return ClassTodo(title: parts[0], time: DateTime.parse(parts[1]));
  }
}
