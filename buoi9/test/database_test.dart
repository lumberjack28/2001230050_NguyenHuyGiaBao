import 'dart:io';

import 'package:buoi9/controllers/auth_controller.dart';
import 'package:buoi9/controllers/expense_controller.dart';
import 'package:buoi9/models/expense.dart';
import 'package:buoi9/utils/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory temp;
  late DatabaseHelper helper;
  late String path;

  setUpAll(sqfliteFfiInit);
  setUp(() async {
    temp = await Directory.systemTemp.createTemp('buoi9_test_');
    path = p.join(temp.path, 'test.db');
    helper = DatabaseHelper(factory: databaseFactoryFfi, databasePath: path);
  });
  tearDown(() async {
    await helper.close();
    await temp.delete(recursive: true);
  });

  test('CRUD, ghi chú, tổng tiền và ID tự tăng sau khi xóa', () async {
    final controller = ExpenseController(database: helper);
    expect(await controller.fetchExpenses(), isEmpty);
    await controller.save(
      const Expense(content: ' Ăn sáng ', amount: 30000, note: ' Bánh mì '),
    );
    await controller.save(const Expense(content: 'Đi xe', amount: 15000));
    var rows = await controller.fetchExpenses();
    expect(rows.map((e) => e.content), ['Đi xe', 'Ăn sáng']);
    expect(rows.last.note, 'Bánh mì');
    expect(rows.fold<int>(0, (sum, e) => sum + e.amount), 45000);
    final firstId = rows.last.id!;
    final highestId = rows.first.id!;
    await controller.save(
      Expense(id: firstId, content: 'Ăn trưa', amount: 50000, note: 'Cơm'),
    );
    await controller.delete(highestId);
    await controller.save(const Expense(content: 'Sách', amount: 120000));
    rows = await controller.fetchExpenses();
    expect(rows.first.id, greaterThan(highestId));
    expect(rows.last.content, 'Ăn trưa');
    expect(rows.last.amount, 50000);
    expect(rows.last.note, 'Cơm');
  });

  test('Khoản chi vẫn tồn tại sau khi đóng và mở lại database', () async {
    await ExpenseController(database: helper)
        .save(const Expense(content: 'Tiền nhà', amount: 2000000));
    await helper.close();
    helper = DatabaseHelper(factory: databaseFactoryFfi, databasePath: path);
    final rows = await ExpenseController(database: helper).fetchExpenses();
    expect(rows.single.content, 'Tiền nhà');
    expect(rows.single.amount, 2000000);
  });

  test('Không lưu nội dung trống hoặc tiền không hợp lệ', () async {
    final controller = ExpenseController(database: helper);
    for (final expense in [
      const Expense(content: ' ', amount: 100),
      const Expense(content: 'X', amount: 0),
      const Expense(content: 'X', amount: -1),
      const Expense(content: 'X', amount: 1000000000000),
    ]) {
      await expectLater(controller.save(expense), throwsArgumentError);
    }
    expect(await controller.fetchExpenses(), isEmpty);
  });

  test('Đăng ký, chuẩn hóa email, lưu bền vững và kiểm tra mật khẩu', () async {
    var auth = AuthController(database: helper);
    await auth.register(' Bao@Example.com ', 'secret123');
    final db = await helper.database;
    final stored = (await db.query('users')).single;
    expect(stored['email'], 'bao@example.com');
    expect(stored.containsKey('password'), isFalse);
    expect(stored['password_hash'], isNot('secret123'));
    await helper.close();
    helper = DatabaseHelper(factory: databaseFactoryFfi, databasePath: path);
    auth = AuthController(database: helper);
    final user = await auth.signIn('BAO@example.com', 'secret123');
    expect(user.email, 'bao@example.com');
    await expectLater(
      auth.signIn('bao@example.com', 'wrong'),
      throwsA(isA<AuthException>()),
    );
    await expectLater(
      auth.signIn('unknown@example.com', 'secret123'),
      throwsA(isA<AuthException>()),
    );
    await expectLater(
      auth.signIn("' OR 1=1 --", 'secret123'),
      throwsA(isA<AuthException>()),
    );
  });

  test(
    'Email trùng bị từ chối, cùng mật khẩu có salt/hash khác nhau',
    () async {
      final auth = AuthController(database: helper);
      await auth.register('one@example.com', 'secret123');
      await auth.register('two@example.com', 'secret123');
      await expectLater(
        auth.register(' ONE@EXAMPLE.COM ', 'other123'),
        throwsA(isA<AuthException>()),
      );
      final rows = await (await helper.database).query('users');
      expect(rows.length, 2);
      expect(rows[0]['password_salt'], isNot(rows[1]['password_salt']));
      expect(rows[0]['password_hash'], isNot(rows[1]['password_hash']));
    },
  );

  test('Đăng ký từ chối email sai và mật khẩu quá ngắn', () async {
    final auth = AuthController(database: helper);
    await expectLater(
      auth.register('invalid', 'secret123'),
      throwsA(isA<AuthException>()),
    );
    await expectLater(
      auth.register('valid@example.com', '123'),
      throwsA(isA<AuthException>()),
    );
    expect(await (await helper.database).query('users'), isEmpty);
  });
}
