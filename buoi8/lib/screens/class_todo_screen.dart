import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/notifications.dart';
import '../common/pick_time.dart';
import '../models/class_todo.dart';
import '../services/class_todo_file.dart';

class ClassTodoScreen extends StatefulWidget {
  const ClassTodoScreen({super.key});

  @override
  State<ClassTodoScreen> createState() => _ClassTodoScreenState();
}

class _ClassTodoScreenState extends State<ClassTodoScreen> {
  final nameController = TextEditingController();
  final service = ClassTodoFile();
  List<ClassTodo> todos = [];
  DateTime? picked;
  bool saving = false;

  String format(DateTime date) => DateFormat('dd/MM/yyyy HH:mm').format(date);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final items = await service.load();
      if (mounted) setState(() => todos = items);
    } catch (e) {
      message('Loi doc todo.txt: $e');
    }
  }

  void message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> save() async {
    final title = nameController.text.trim();
    if (title.isEmpty || picked == null) {
      message('Nhap cong viec va chon ngay gio');
      return;
    }
    if (title.contains('|') || title.contains('\n')) {
      message('Ten cong viec khong duoc co ky tu | hoac xuong dong');
      return;
    }
    if (!picked!.isAfter(DateTime.now())) {
      message('Gio nhac phai o tuong lai');
      return;
    }
    setState(() => saving = true);
    final item = ClassTodo(title: title, time: picked!);
    final newTodos = [...todos, item];
    try {
      await service.save(newTodos);
      if (!mounted) return;
      setState(() {
        todos = newTodos;
        picked = null;
        nameController.clear();
      });
      await Notifications.instance.show('Da them lich', 'Da luu: $title');
      final exact = await Notifications.instance.schedule(
        id: Notifications.newId(),
        title: 'Nhac cong viec',
        message: title,
        when: item.time,
      );
      message(exact
          ? 'Da luu todo.txt va hen gio nhac'
          : 'Da luu; gio nhac co the den tre neu chua cap quyen bao thuc');
    } catch (e) {
      message('Khong the hoan tat: $e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.yellow.shade100,
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Bai 3 - Todo nhac viec')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Ten cong viec',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: Text(picked == null
                  ? 'Chua chon thoi gian'
                  : format(picked!)),
            ),
            OutlinedButton(
              onPressed: () async {
                final date = await chooseDateTime(context);
                if (date != null && mounted) setState(() => picked = date);
              },
              child: const Text('Chon thoi gian'),
            ),
          ]),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: saving ? null : save,
            child: const Text('Luu'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final item = todos[index];
                return Card(
                  color: colors[index % colors.length],
                  child: ListTile(
                    leading: const Icon(Icons.task_alt),
                    title: Text(item.title),
                    subtitle: Text(format(item.time)),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
