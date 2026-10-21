import '../models/expense.dart';
import '../utils/database_helper.dart';
import '../utils/validators.dart';

class ExpenseController {
  ExpenseController({DatabaseHelper? database})
    : _helper = database ?? DatabaseHelper.instance;
  final DatabaseHelper _helper;
  Future<List<Expense>> fetchExpenses() async {
    final db = await _helper.database;
    final rows = await db.query('expenses', orderBy: 'id DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<void> save(Expense expense) async {
    if (Validators.content(expense.content) != null ||
        Validators.amount(expense.amount.toString()) != null) {
      throw ArgumentError('Thông tin chi tiêu không hợp lệ.');
    }
    final db = await _helper.database;
    final values = Expense(
      id: expense.id,
      content: expense.content.trim(),
      amount: expense.amount,
      note: expense.note.trim(),
    ).toMap();
    if (expense.id == null) {
      await db.insert('expenses', values);
    } else {
      await db.update(
        'expenses',
        values,
        where: 'id = ?',
        whereArgs: [expense.id],
      );
    }
  }

  Future<void> delete(int id) async {
    final db = await _helper.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
