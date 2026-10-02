class SmsMessageModel {
  final String id;
  final String sender;
  final String body;
  final DateTime date;

  SmsMessageModel({
    required this.id,
    required this.sender,
    required this.body,
    required this.date,
  });

  // Kiểm tra tin nhắn quảng cáo: bắt đầu bằng [QC]
  bool get isAdvertisement {
    return body.trim().toUpperCase().startsWith('[QC]');
  }

  // Kiểm tra tin nhắn OTP: có chuỗi [OTP] kèm 6 chữ số liên tiếp
  bool get isOtp {
    final regex = RegExp(r'\[OTP\][^\d]*(\d{6})', caseSensitive: false);
    return regex.hasMatch(body);
  }

  // Trích xuất mã OTP gồm 6 chữ số
  String? extractOtpCode() {
    final regex = RegExp(r'\[OTP\][^\d]*(\d{6})', caseSensitive: false);
    final match = regex.firstMatch(body);
    return match?.group(1);
  }
}

// Dữ liệu mẫu phục vụ kiểm thử bài tập
final List<SmsMessageModel> sampleSmsList = [
  SmsMessageModel(
    id: '1',
    sender: '0901234567',
    body: '[QC] Giam gia 50% toan bo khoa hoc lap trinh dip cuoi nam. Dang ky ngay tai website.',
    date: DateTime(2026, 10, 1, 9, 30),
  ),
  SmsMessageModel(
    id: '2',
    sender: 'BANK_AUTH',
    body: 'Ma xac thuc [OTP] 829104 cho giao dich chuyen khoan 500.000 VND. Khong chia se ma nay.',
    date: DateTime(2026, 10, 1, 10, 15),
  ),
  SmsMessageModel(
    id: '3',
    sender: '0988776655',
    body: 'Chieu nay 2h hop nhom do an tot nghiep o phong lab nhe!',
    date: DateTime(2026, 10, 1, 11, 00),
  ),
  SmsMessageModel(
    id: '4',
    sender: '0901234567',
    body: '[QC] Mua 1 tang 1 tra sua toi nay tu 18h den 21h. Chi tiet xem tai app.',
    date: DateTime(2026, 9, 30, 15, 20),
  ),
  SmsMessageModel(
    id: '5',
    sender: 'SERVICE_OTP',
    body: '[OTP] 105934 la ma dang nhap tai khoan cua ban, hieu luc trong 5 phut.',
    date: DateTime(2026, 9, 30, 16, 45),
  ),
  SmsMessageModel(
    id: '6',
    sender: '0912345678',
    body: 'Tai lieu tham khao Flutter va Dart anh da gui qua email roi nhe.',
    date: DateTime(2026, 9, 29, 8, 10),
  ),
  SmsMessageModel(
    id: '7',
    sender: 'VIETTEL',
    body: '[QC] Quy khach duoc tang 20% gia tri the nap khi thanh toan truc tuyen hom nay.',
    date: DateTime(2026, 9, 29, 14, 05),
  ),
  SmsMessageModel(
    id: '8',
    sender: 'ZALOPAY',
    body: 'Xac thuc lien ket vi dien tu. Ma [OTP] 647201. Tuyet doi khong chia se cho bat ky ai.',
    date: DateTime(2026, 9, 28, 20, 30),
  ),
];
