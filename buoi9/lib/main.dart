import 'package:flutter/material.dart';

import 'views/expense_screen.dart';
import 'views/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Bai09App());
}

class Bai09App extends StatelessWidget {
  const Bai09App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bài 09 - SQLite',
    theme: ThemeData(
      colorSchemeSeed: Colors.blue,
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: const ExerciseMenuScreen(),
  );
}

class ExerciseMenuScreen extends StatelessWidget {
  const ExerciseMenuScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bài 09 - Bài tập về nhà')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Làm việc với cơ sở dữ liệu SQLite',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Bài 1. Quản lý chi tiêu cá nhân'),
            subtitle: const Text('Nội dung, số tiền, ghi chú · Thêm, sửa, xóa'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ExpenseScreen()),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Bài 2. Đăng nhập và đăng ký'),
            subtitle: const Text(
              'Tài khoản email và mật khẩu lưu trong SQLite',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
            ),
          ),
        ),
      ],
    ),
  );
}
