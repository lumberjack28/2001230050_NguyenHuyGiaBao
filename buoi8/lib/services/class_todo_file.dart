import '../common/file_store.dart';
import '../models/class_todo.dart';

class ClassTodoFile {
  Future<List<ClassTodo>> load() async {
    final file = await FileStore.file('todo.txt');
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    return content
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map(ClassTodo.fromLine)
        .toList();
  }

  Future<void> save(List<ClassTodo> todos) async {
    final file = await FileStore.file('todo.txt');
    await file.writeAsString(todos.map((item) => item.toLine()).join('\n'));
  }
}
