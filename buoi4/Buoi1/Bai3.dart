import 'dart:io';
import 'dart:math';

bool isPrime(int n) {
  if (n < 2) return false;
  for (int i = 2; i <= sqrt(n); i++) {
    if (n % i == 0) return false;
  }
  return true;
}

void main() {
  List<int> numbers = [];

  int n = 0;
  while (true) {
    stdout.write('Nhập số lượng phần tử của danh sách (n > 0): ');
    int? parsed = int.tryParse(stdin.readLineSync() ?? '');
    if (parsed != null && parsed > 0) {
      n = parsed;
      break;
    }
    print('Vui lòng nhập một số nguyên dương hợp lệ!\n');
  }

  for (int i = 0; i < n; i++) {
    while (true) {
      stdout.write('Nhập phần tử thứ ${i + 1}: ');
      int? val = int.tryParse(stdin.readLineSync() ?? '');
      if (val != null) {
        numbers.add(val);
        break;
      }
      print('Giá trị không hợp lệ! Vui lòng nhập số nguyên.');
    }
  }

  print('\n================== KẾT QUẢ ==================');

  // a. Xuất danh sách vừa nhập
  print('a. Danh sách vừa nhập: $numbers');

  // b. Tính tổng các phần tử
  int totalSum = numbers.reduce((a, b) => a + b);
  // Hoặc dùng vòng lặp for / fold(0, (sum, e) => sum + e)
  print('b. Tổng các phần tử trong danh sách: $totalSum');

  // c. Xuất các phần tử là số nguyên tố
  List<int> primeNumbers = numbers.where((num) => isPrime(num)).toList();
  if (primeNumbers.isNotEmpty) {
    print('c. Các số nguyên tố trong danh sách: $primeNumbers');
  } else {
    print('c. Không có số nguyên tố nào trong danh sách.');
  }

  // d. Tìm kiếm hoặc chèn vào đầu danh sách
  print('\n--- Xử lý câu d ---');
  int x = 0;
  while (true) {
    stdout.write('Nhập vào một giá trị cần tìm (x): ');
    int? parsed = int.tryParse(stdin.readLineSync() ?? '');
    if (parsed != null) {
      x = parsed;
      break;
    }
    print('Vui lòng nhập một số nguyên hợp lệ!');
  }

  List<int> positions = [];
  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == x) {
      positions.add(i);
    }
  }

  if (positions.isNotEmpty) {
    print(
      'Giá trị $x CÓ trong danh sách tại các vị trí index: $positions (hoặc thứ tự: ${positions.map((p) => p + 1).toList()})',
    );
  } else {
    print('Giá trị $x KHÔNG có trong danh sách.');
    numbers.insert(0, x);
    print('-> Đã thêm $x vào đầu danh sách.');
    print('-> Danh sách mới sau khi thêm: $numbers');
  }
}
