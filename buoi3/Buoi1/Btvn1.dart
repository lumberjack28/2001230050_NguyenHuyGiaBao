import 'dart:io';
import 'dart:math';

void main() {
  int n = 0;
  while (true) {
    stdout.write('Nhập số lượng phần tử cần tạo (n > 0): ');
    int? parsed = int.tryParse(stdin.readLineSync() ?? '');
    if (parsed != null && parsed > 0) {
      n = parsed;
      break;
    }
    print('Vui lòng nhập số nguyên dương hợp lệ!\n');
  }

  Random rand = Random();
  List<int> list = List.generate(n, (_) => 5 + rand.nextInt(96));

  print('\nKẾT QUẢ');

  print('a. Danh sách phần tử: $list');

  int totalSum = list.reduce((a, b) => a + b);
  print('b. Tổng các phần tử: $totalSum');

  List<int> oddNumbers = list.where((x) => x % 2 != 0).toList();
  if (oddNumbers.isNotEmpty) {
    double oddAvg = oddNumbers.reduce((a, b) => a + b) / oddNumbers.length;
    print('c. Trung bình cộng các số lẻ: ${oddAvg.toStringAsFixed(2)}');
  } else {
    print('c. Danh sách không có số lẻ.');
  }

  bool isSymmetric = true;
  for (int i = 0; i < list.length ~/ 2; i++) {
    if (list[i] != list[list.length - 1 - i]) {
      isSymmetric = false;
      break;
    }
  }
  print('d. Danh sách đối xứng: ${isSymmetric ? "Có" : "Không"}');

  bool isAscending = true;
  for (int i = 0; i < list.length - 1; i++) {
    if (list[i] > list[i + 1]) {
      isAscending = false;
      break;
    }
  }
  print('e. Danh sách sắp xếp tăng dần: ${isAscending ? "Có" : "Không"}');

  int maxVal = list.reduce(max);
  print('f. Phần tử lớn nhất: $maxVal');

  List<int> evenNumbers = list.where((x) => x % 2 == 0).toList();
  if (evenNumbers.isNotEmpty) {
    int maxEven = evenNumbers.reduce(max);
    print('g. Phần tử là số chẵn lớn nhất: $maxEven');
  } else {
    print('g. Danh sách không có số chẵn.');
  }

  print('\n--- Xử lý câu h ---');
  int target = 0;
  while (true) {
    stdout.write('Nhập vào giá trị cần tìm và xóa: ');
    int? parsed = int.tryParse(stdin.readLineSync() ?? '');
    if (parsed != null) {
      target = parsed;
      break;
    }
    print('Vui lòng nhập một số nguyên hợp lệ!');
  }

  if (list.contains(target)) {
    list.removeWhere((item) => item == target);
    print('-> Đã tìm thấy và xóa tất cả phần tử có giá trị $target.');
    print('-> Danh sách sau khi xóa: $list');
  } else {
    print('Không tìm thấy.');
  }
}
