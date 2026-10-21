class Expense {
  const Expense({
    this.id,
    required this.content,
    required this.amount,
    this.note = '',
  });
  final int? id;
  final String content;

  /// Số tiền nguyên theo đơn vị đồng, tránh sai số số thực.
  final int amount;
  final String note;
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'content': content,
    'amount': amount,
    'note': note,
  };
  factory Expense.fromMap(Map<String, Object?> map) => Expense(
    id: map['id'] as int,
    content: map['content'] as String,
    amount: map['amount'] as int,
    note: map['note'] as String,
  );
}
