import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../utils/validators.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key, required this.controller, this.expense});
  final ExpenseController controller;
  final Expense? expense;
  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _content = TextEditingController(text: widget.expense?.content);
  late final _amount = TextEditingController(
    text: widget.expense?.amount.toString(),
  );
  late final _note = TextEditingController(text: widget.expense?.note);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _content.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.controller.save(
        Expense(
          id: widget.expense?.id,
          content: _content.text,
          amount: int.parse(_amount.text.trim()),
          note: _note.text,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Không thể lưu. Kiểm tra dữ liệu và thử lại.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? 'Thêm khoản chi' : 'Sửa khoản chi',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                TextFormField(
                  controller: _content,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung chi tiêu *',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: Validators.content,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amount,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Số tiền (VNĐ) *',
                    helperText: 'Nhập số nguyên, ví dụ: 50000',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: Validators.amount,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _note,
                  enabled: !_saving,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Ghi chú'),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Đang lưu...' : 'Lưu'),
                ),
                TextButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
