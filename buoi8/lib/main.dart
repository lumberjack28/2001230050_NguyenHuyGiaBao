import 'package:flutter/material.dart';
import 'common/notifications.dart';
import 'screens/class_todo_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'screens/home_todo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notifications.instance.init();
  runApp(const Bai08App());
}

class Bai08App extends StatelessWidget {
  const Bai08App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bai 08 - Notification va File',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ExerciseMenuScreen(),
    );
  }
}

class ExerciseMenuScreen extends StatelessWidget {
  const ExerciseMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bai 08 - Chon bai tap')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Bai 3 tren lop'),
            subtitle: const Text('Todo, todo.txt, notification hen gio'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClassTodoScreen()),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Bai 4 tren lop'),
            subtitle: const Text('Hoc tu vung, kiem tra, lich nhac'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VocabularyScreen()),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Bai 4 ve nha'),
            subtitle: const Text('TodoList, checkbox, chuong nhac'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeTodoScreen()),
            ),
          ),
        ),
      ]),
    );
  }
}
