# Bài 09 - Làm việc với cơ sở dữ liệu SQLite

**Sinh viên:** Nguyễn Huy Gia Bảo - **MSSV:** 2001230050

Hoàn thành hai bài thuộc phần **C. BÀI TẬP VỀ NHÀ** (trang 13) của tài liệu `Bai09_Chuong5_XuLyCoSoDuLieu.pdf`.

## Chạy project

Yêu cầu Flutter có Dart >= 3.13.0. Mở terminal tại thư mục `buoi9`:

```powershell
flutter pub get
flutter run
```

Chọn thiết bị Android/iOS hoặc Windows, sau đó chọn bài từ màn hình chính.

```powershell
flutter run -d windows
flutter build apk --debug
```

- Android: cần Android SDK, Command-line Tools và chấp nhận license (`flutter doctor --android-licenses`).
- Windows: cần Visual Studio với workload **Desktop development with C++**. SQLite dùng `sqflite_common_ffi`.
- iOS: build trên macOS có Xcode.
- Project không cấu hình Flutter Web; hãy dùng thiết bị/emulator Android, iOS hoặc Windows.

## Bài 1 - Quản lý chi tiêu cá nhân

- Mỗi khoản chi có **nội dung chi tiêu, số tiền, ghi chú**.
- Xem danh sách và tổng chi tiêu bằng VNĐ.
- Chọn **Thêm khoản chi**, nhập dữ liệu rồi **Lưu**; **Hủy** quay lại, không ghi dữ liệu.
- Nhấn khoản chi hoặc menu **Sửa** để cập nhật. Menu **Xóa** có hộp thoại xác nhận.
- Nội dung bắt buộc; số tiền là số nguyên dương từ 1 đến 999999999999 đồng; ghi chú tùy chọn.
- Danh sách và tổng được nạp lại sau khi lưu/xóa; kéo xuống để tải lại.
- Dữ liệu nằm trong SQLite, được giữ khi đóng và mở lại ứng dụng.

## Bài 2 - Đăng nhập và đăng ký

- Form đăng nhập có **Email**, **Password**, **Sign in**, **Register**, bố cục cơ bản theo hình đề bài.
- Chọn **Register**, nhập email, mật khẩu (ít nhất 6 ký tự), xác nhận mật khẩu rồi **Đăng ký**.
- Email trùng bị từ chối; email được chuẩn hóa về chữ thường và bỏ khoảng trắng hai đầu.
- Đăng ký thành công quay về đăng nhập, điền sẵn email và thông báo kết quả.
- **Sign in** tra tài khoản trong SQLite và xác minh mật khẩu; đúng thì hiện hộp thoại **Đăng nhập thành công**, sai thì báo lỗi.
- Có nút ẩn/hiện mật khẩu và kiểm tra trường nhập. Mật khẩu giữ nguyên ký tự người dùng nhập, không tự trim.
- Mật khẩu không lưu dạng rõ: dùng PBKDF2-HMAC-SHA256, 210000 vòng, salt ngẫu nhiên 16 byte, khóa băm 32 byte.
- Đây là bài lab xác thực tài khoản cục bộ trên thiết bị; hai bài độc lập, không có server hay phân chia chi tiêu theo tài khoản.

## Tổ chức mã nguồn (MVC)

```text
lib/
  main.dart                       # Menu chọn hai bài
  models/
    expense.dart                  # Model chi tiêu, toMap/fromMap
    app_user.dart                 # Thông tin tài khoản cho view
  utils/
    database_helper.dart          # Mở database và tạo bảng
    validators.dart               # Kiểm tra dữ liệu nhập
  controllers/
    expense_controller.dart       # Thêm, sửa, xóa, truy vấn chi tiêu
    auth_controller.dart          # Đăng ký, băm mật khẩu, đăng nhập
  views/
    expense_screen.dart           # Danh sách, tổng chi và xóa
    expense_form_screen.dart      # Thêm/sửa chi tiêu
    login_screen.dart             # Form Sign in/Register
    register_screen.dart          # Form tạo tài khoản
test/
  database_test.dart              # SQLite thực: CRUD, lưu bền vững, xác thực
  widget_test.dart                # Điều hướng, validation, bố cục biểu mẫu
```

Database `buoi9.db` được tạo tự động trong thư mục database của ứng dụng. Không cần file dữ liệu mẫu hoặc tài khoản có sẵn. Gỡ ứng dụng/xóa dữ liệu ứng dụng sẽ xóa cả dữ liệu của bài lab.

```sql
CREATE TABLE expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  content TEXT NOT NULL CHECK(length(trim(content)) > 0),
  amount INTEGER NOT NULL CHECK(amount > 0 AND amount <= 999999999999),
  note TEXT NOT NULL DEFAULT ''
);
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL COLLATE NOCASE UNIQUE,
  password_hash TEXT NOT NULL,
  password_salt TEXT NOT NULL
);
```

Controller sử dụng `whereArgs` để truyền tham số truy vấn, SQLite cấp ID tự tăng.

## Kiểm tra

```powershell
flutter analyze
flutter test
```

Kiểm thử dùng database SQLite riêng trong thư mục tạm, không đụng dữ liệu của ứng dụng:

- CRUD, tổng số tiền, ID tự tăng sau khi xóa và dữ liệu còn sau khi mở lại database.
- Từ chối khoản chi trống/số tiền không hợp lệ.
- Đăng ký, đăng nhập đúng/sai, email không tồn tại, email trùng, dữ liệu đăng nhập còn sau khi mở lại database.
- Salt/hash khác nhau cho hai tài khoản dùng cùng mật khẩu; không có cột lưu mật khẩu rõ.
- Chuỗi chèn SQL không vượt qua đăng nhập.
- Điều hướng, lỗi biểu mẫu, xác nhận mật khẩu và bố cục 320×568, 412×915, 800×600, 1024×768 có bàn phím.

Thư viện: [sqflite](https://pub.dev/packages/sqflite), [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi), [cryptography](https://pub.dev/packages/cryptography), `intl`, `path`.

### Kết quả trên máy hiện tại

- Flutter 3.47.7 / Dart 3.13.5: `flutter analyze` không có vấn đề; `flutter test` đạt 12/12.
- Đã kết xuất và kiểm tra trực quan các màn hình menu, danh sách chi tiêu, thêm chi tiêu, đăng nhập và đăng ký.
- Chưa tạo được APK: Gradle dừng với `java.io.IOException: Unable to establish loopback connection`. `flutter doctor` cũng báo thiếu Android Command-line Tools. Chưa xác nhận chạy trên emulator/điện thoại thật.
- Chưa build Windows vì máy chưa có Visual Studio C++ toolchain; chưa build iOS vì đang làm việc trên Windows.
