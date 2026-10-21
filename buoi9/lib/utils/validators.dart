class Validators {
  static String? email(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Vui lòng nhập email.';
    if (email.length > 254 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Email không đúng định dạng.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu.';
    if (value.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự.';
    return null;
  }

  static String? content(String? value) =>
      (value ?? '').trim().isEmpty ? 'Vui lòng nhập nội dung chi tiêu.' : null;
  static String? amount(String? value) {
    final text = (value ?? '').trim();
    final amount = int.tryParse(text);
    if (!RegExp(r'^[0-9]+$').hasMatch(text) ||
        amount == null ||
        amount <= 0 ||
        amount > 999999999999) {
      return 'Nhập số nguyên từ 1 đến 999999999999 đồng.';
    }
    return null;
  }
}
