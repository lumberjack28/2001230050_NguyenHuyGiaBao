import 'package:flutter/material.dart';
import 'bai1.dart';
import 'bai3.dart';
import 'bai4.dart';
import 'bai5.dart';
import 'bai6.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài Tập Thực Hành',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Bài Tập'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bài tập 01
          Card(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(child: Text('01')),
              title: const Text('Bài tập 01', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Ứng dụng máy tính (Windows Calculator)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai1Screen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Bài tập 03
          Card(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(child: Text('03')),
              title: const Text('Bài tập 03', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Giao diện thể hiện tình trạng người dùng trong ngày'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai3Screen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Bài tập 04
          Card(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(child: Text('04')),
              title: const Text('Bài tập 04', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Giao diện mô phỏng ví điện tử (My Cards)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai4Screen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Bài tập 05
          Card(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(child: Text('05')),
              title: const Text('Bài tập 05', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Giao diện đăng ký khám chữa bệnh online'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai5Screen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Bài tập 06
          Card(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(child: Text('06')),
              title: const Text('Bài tập 06', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Giao diện màn hình nghe nhạc (Neumorphism Music Player)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai6Screen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
