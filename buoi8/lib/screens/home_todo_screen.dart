import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/notifications.dart';
import '../common/pick_time.dart';
import '../models/home_task.dart';
import '../services/home_task_file.dart';

class HomeTodoScreen extends StatefulWidget {
  const HomeTodoScreen({super.key});

  @override
  State<HomeTodoScreen> createState() => _HomeTodoScreenState();
}

class _HomeTodoScreenState extends State<HomeTodoScreen> {
  final file = HomeTaskFile();
  List<HomeTask> tasks = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> refresh() async {
    try {
      final items = await file.load();
      if (mounted) setState(() => tasks = items);
    } catch (e) {
      message('Loi doc file: $e');
    }
  }

  Future<void> openAdd() async {
    final newTask = await Navigator.push<HomeTask>(
      context,
      MaterialPageRoute(builder: (_) => const AddHomeTaskScreen()),
    );
    if (newTask == null) return;
    final updated = [...tasks, newTask];
    try {
      await file.save(updated);
      if (!mounted) return;
      setState(() => tasks = updated);
      if (newTask.reminder != null) {
        await Notifications.instance.schedule(
          id: newTask.id,
          title: 'Nhac nhiem vu',
          message: newTask.title,
          when: newTask.reminder!,
        );
      }
      message('Da luu nhiem vu vao home_tasks.json');
    } catch (e) {
      message('Loi luu nhiem vu hoac dat lich: $e');
    }
  }

  Future<void> setReminder(HomeTask task) async {
    final picked = await chooseDateTime(context);
    if (picked == null || !mounted) return;
    if (!picked.isAfter(DateTime.now())) {
      message('Thoi gian phai o tuong lai');
      return;
    }
    final updated = tasks
        .map((item) => item.id == task.id
            ? item.copyWith(reminder: picked)
            : item)
        .toList();
    try {
      await file.save(updated);
      if (mounted) setState(() => tasks = updated);
      await Notifications.instance.cancel(task.id);
      await Notifications.instance.schedule(
        id: task.id,
        title: 'Nhac nhiem vu',
        message: task.title,
        when: picked,
      );
      message('Da hen gio nhac');
    } catch (e) {
      message('Loi dat lich: $e');
    }
  }

  Future<void> confirmDone(HomeTask task) async {
    if (task.done) return;
    final agree = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xac nhan hoan thanh'),
        content: Text('Ban da hoan thanh nhiem vu "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Khong'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Co'),
          ),
        ],
      ),
    );
    if (agree != true || !mounted) return;
    final updated = tasks
        .map((item) => item.id == task.id ? item.copyWith(done: true) : item)
        .toList();
    try {
      await file.save(updated);
      if (mounted) setState(() => tasks = updated);
      await Notifications.instance.cancel(task.id);
      final count = updated.where((item) => item.done).length;
      await Notifications.instance.show(
        'Thong ke nhiem vu',
        'Ban da hoan thanh $count/${updated.length} nhiem vu',
      );
      message('Da danh dau hoan thanh');
    } catch (e) {
      message('Loi hoan thanh nhiem vu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhiem vu moi ngay')),
      floatingActionButton: FloatingActionButton(
        onPressed: openAdd,
        child: const Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Chua co nhiem vu. Nhan + de them.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  color: Colors.grey.shade100,
                  child: ListTile(
                    leading: Checkbox(
                      value: task.done,
                      onChanged: task.done ? null : (_) => confirmDone(task),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(task.done
                        ? 'Da hoan thanh'
                        : task.reminder == null
                            ? 'Chua hen gio'
                            : 'Nhac luc ${DateFormat('dd/MM HH:mm').format(task.reminder!)}'),
                    trailing: IconButton(
                      icon: Icon(task.reminder == null
                          ? Icons.notifications_none
                          : Icons.notifications_active),
                      onPressed: task.done ? null : () => setReminder(task),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AddHomeTaskScreen extends StatefulWidget {
  const AddHomeTaskScreen({super.key});

  @override
  State<AddHomeTaskScreen> createState() => _AddHomeTaskScreenState();
}

class _AddHomeTaskScreenState extends State<AddHomeTaskScreen> {
  final controller = TextEditingController();
  DateTime? reminder;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void save() {
    final title = controller.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hay nhap ten nhiem vu')),
      );
      return;
    }
    if (reminder != null && !reminder!.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gio nhac phai o tuong lai')),
      );
      return;
    }
    Navigator.pop(
      context,
      HomeTask(id: Notifications.newId(), title: title, reminder: reminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Them nhiem vu moi')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Ten nhiem vu',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final time = await chooseDateTime(context);
              if (time != null && mounted) setState(() => reminder = time);
            },
            icon: const Icon(Icons.notifications_outlined),
            label: Text(reminder == null
                ? 'Gio nhac (khong bat buoc)'
                : DateFormat('dd/MM/yyyy HH:mm').format(reminder!)),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: save, child: const Text('Luu nhiem vu')),
        ]),
      ),
    );
  }
}
