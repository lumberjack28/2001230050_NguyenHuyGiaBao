import 'dart:io';

void main() {
  int quantity = 0;
  while (true) {
    stdout.write('Nhập số que kem cần mua: ');
    String? input = stdin.readLineSync();
    int? parsed = int.tryParse(input ?? '');

    if (parsed != null && parsed > 0) {
      quantity = parsed;
      break;
    }
    print('Số lượng không hợp lệ! Vui lòng nhập số nguyên lớn hơn 0.\n');
  }

  double price = 0;
  while (true) {
    stdout.write('Nhập đơn giá cho một que kem: ');
    String? input = stdin.readLineSync();
    double? parsed = double.tryParse(input ?? '');

    if (parsed != null && parsed > 0) {
      price = parsed;
      break;
    }
    print('Giá tiền không hợp lệ! Vui lòng nhập số lớn hơn 0.\n');
  }

  double total = quantity * price;

  double discountRate = 0.0;
  if (quantity > 10) {
    discountRate = 0.10;
  } else if (quantity >= 5) {
    discountRate = 0.05;
  }

  double discountAmount = total * discountRate;
  double finalAmount = total - discountAmount;

  print('\nHÓA ĐƠN');
  print('Số lượng que kem: $quantity');
  print('Đơn giá: ${price.toStringAsFixed(0)} VND');
  print('Tổng tiền gốc: ${total.toStringAsFixed(0)} VND');
  print(
    'Giảm giá: ${(discountRate * 100).toInt()}% (-${discountAmount.toStringAsFixed(0)} VND)',
  );
  print('Số tiền phải trả: ${finalAmount.toStringAsFixed(0)} VND');
}
