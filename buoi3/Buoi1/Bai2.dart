import 'dart:io';

bool isPrimeDigit(int digit) {
  return digit == 2 || digit == 3 || digit == 5 || digit == 7;
}

void main() {
  int n = 0;

  while (true) {
    stdout.write('Nhập vào một số nguyên dương > 10: ');
    String? input = stdin.readLineSync();
    int? parsed = int.tryParse(input ?? '');

    if (parsed != null && parsed > 10) {
      n = parsed;
      break;
    }
    print('Giá trị không hợp lệ! Vui lòng nhập số nguyên lớn hơn 10.\n');
  }

  int temp = n;
  int count = 0; // a. Đếm số chữ số
  int sum = 0; // b. Tổng các chữ số
  bool hasOdd = false; // c. Chứa chữ số lẻ hay không
  int maxDigit = 0; // d. Chữ số lớn nhất
  bool hasPrimeDigit = false; // e. Chứa chữ số nguyên tố hay không

  while (temp > 0) {
    int digit = temp % 10;

    count++;

    sum += digit;

    if (digit % 2 != 0) {
      hasOdd = true;
    }

    if (digit > maxDigit) {
      maxDigit = digit;
    }

    if (isPrimeDigit(digit)) {
      hasPrimeDigit = true;
    }

    temp ~/= 10;
  }

  print('\nKẾT QUẢ');
  print('Số nguyên đã nhập: $n');
  print('a. Số lượng chữ số: $count');
  print('b. Tổng các chữ số: $sum');
  print('c. Có chứa chữ số lẻ không: ${hasOdd ? "Có" : "Không"}');
  print('d. Chữ số lớn nhất: $maxDigit');
  print('e. Có chứa chữ số nguyên tố không: ${hasPrimeDigit ? "Có" : "Không"}');
}
