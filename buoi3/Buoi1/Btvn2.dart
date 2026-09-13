import 'dart:io';

final Set<String> vowels = {
  // Tiếng Anh
  'a', 'e', 'i', 'o', 'u', 'y',
  'A', 'E', 'I', 'O', 'U', 'Y',
  // Tiếng Việt - a, ă, â
  'á',
  'à',
  'ả',
  'ã',
  'ạ',
  'ă',
  'ắ',
  'ằ',
  'ẳ',
  'ẵ',
  'ặ',
  'â',
  'ấ',
  'ầ',
  'ẩ',
  'ẫ',
  'ậ',
  'Á',
  'À',
  'Ả',
  'Ã',
  'Ạ',
  'Ă',
  'Ắ',
  'Ằ',
  'Ẳ',
  'Ẵ',
  'Ặ',
  'Â',
  'Ấ',
  'Ầ',
  'Ẩ',
  'Ẫ',
  'Ậ',
  // Tiếng Việt - e, ê
  'é', 'è', 'ẻ', 'ẽ', 'ẹ', 'ê', 'ế', 'ề', 'ể', 'ễ', 'ệ',
  'É', 'È', 'Ẻ', 'Ẽ', 'Ẹ', 'Ê', 'Ế', 'Ề', 'Ể', 'Ễ', 'Ệ',
  // Tiếng Việt - i
  'í', 'ì', 'ỉ', 'ĩ', 'ị',
  'Í', 'Ì', 'Ỉ', 'Ĩ', 'Ị',
  // Tiếng Việt - o, ô, ơ
  'ó',
  'ò',
  'ỏ',
  'õ',
  'ọ',
  'ô',
  'ố',
  'ồ',
  'ổ',
  'ỗ',
  'ộ',
  'ơ',
  'ớ',
  'ờ',
  'ở',
  'ỡ',
  'ợ',
  'Ó',
  'Ò',
  'Ỏ',
  'Õ',
  'Ọ',
  'Ô',
  'Ố',
  'Ồ',
  'Ổ',
  'Ỗ',
  'Ộ',
  'Ơ',
  'Ớ',
  'Ờ',
  'Ở',
  'Ỡ',
  'Ợ',
  // Tiếng Việt - u, ư
  'ú', 'ù', 'ủ', 'ũ', 'ụ', 'ư', 'ứ', 'ừ', 'ử', 'ữ', 'ự',
  'Ú', 'Ù', 'Ủ', 'Ũ', 'Ụ', 'Ư', 'Ứ', 'Ừ', 'Ử', 'Ữ', 'Ự',
  // Tiếng Việt - y
  'ý', 'ỳ', 'ỷ', 'ỹ', 'ỵ',
  'Ý', 'Ỳ', 'Ỷ', 'Ỹ', 'Ỵ',
};
void main() {
  stdout.write('Nhập vào một chuỗi bất kỳ: ');
  String input = stdin.readLineSync() ?? '';

  print('\nKẾT QUẢ');
  print('a. Chuỗi vừa nhập: "$input"');

  int vowelCount = 0;
  for (int i = 0; i < input.length; i++) {
    if (vowels.contains(input[i])) {
      vowelCount++;
    }
  }
  print('b. Số ký tự nguyên âm: $vowelCount');

  // c. Đếm số lượng từ (tách theo 1 hoặc nhiều khoảng trắng liên tiếp)
  String trimmed = input.trim();
  List<String> words = trimmed.isEmpty ? [] : trimmed.split(RegExp(r'\s+'));
  print('c. Số từ trong chuỗi: ${words.length}');

  // d. Kiểm tra chuỗi có đối xứng hay không (Palindrome)
  String cleanStr = input.replaceAll(' ', '').toLowerCase();
  String reversedStr = cleanStr.split('').reversed.join('');
  bool isSymmetric = cleanStr.isNotEmpty && cleanStr == reversedStr;
  print('d. Chuỗi đối xứng: ${isSymmetric ? "Có" : "Không"}');

  // e. Đảo ngược các từ trong chuỗi
  if (words.isNotEmpty) {
    String reversedWords = words.reversed.join(' ');
    print('e. Đảo ngược từ: "$reversedWords"');
  } else {
    print('e. Đảo ngược từ: ""');
  }
}
