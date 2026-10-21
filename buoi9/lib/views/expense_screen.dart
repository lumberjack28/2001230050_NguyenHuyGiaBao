import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import 'expense_form_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key, this.controller});
  final ExpenseController? controller;
  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  late final _controller = widget.controller ?? ExpenseController();
  final _money = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );
  List<Expense> _expenses = [];
  bool _loading = true;
  bool _deleting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _controller.fetchExpenses();
      if (mounted) setState(() => _expenses = items);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Không thể đọc dữ liệu. Vui lòng thử lại.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _edit([Expense? expense]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ExpenseFormScreen(expense: expense, controller: _controller),
      ),
    );
    if (saved == true && mounted) await _load();
  }

  Future<void> _delete(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa khoản chi?'),
        content: Text('Bạn muốn xóa “${expense.content}”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await _controller.delete(expense.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã xóa khoản chi.')));
      await _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể xóa khoản chi. Vui lòng thử lại.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _expenses.fold<int>(0, (sum, item) => sum + item.amount);
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý chi tiêu')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading || _deleting ? null : () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm khoản chi'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  TextButton(onPressed: _load, child: const Text('Thử lại')),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tổng chi tiêu · ${_expenses.length} khoản'),
                          const SizedBox(height: 8),
                          Text(
                            _money.format(total),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_expenses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Chưa có khoản chi. Chọn “Thêm khoản chi” để bắt đầu.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  for (final expense in _expenses)
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(expense.content),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _money.format(expense.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (expense.note.isNotEmpty) Text(expense.note),
                          ],
                        ),
                        onTap: _deleting ? null : () => _edit(expense),
                        trailing: PopupMenuButton<String>(
                          enabled: !_deleting,
                          tooltip: 'Thao tác khoản chi',
                          onSelected: (action) {
                            if (action == 'edit') {
                              _edit(expense);
                            } else {
                              _delete(expense);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Sửa')),
                            PopupMenuItem(value: 'delete', child: Text('Xóa')),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
