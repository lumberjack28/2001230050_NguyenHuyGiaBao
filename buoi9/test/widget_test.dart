import 'package:buoi9/controllers/auth_controller.dart';
import 'package:buoi9/controllers/expense_controller.dart';
import 'package:buoi9/main.dart';
import 'package:buoi9/views/expense_form_screen.dart';
import 'package:buoi9/views/login_screen.dart';
import 'package:buoi9/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Menu mở đúng bài 2 và form báo lỗi khi bỏ trống', (
    tester,
  ) async {
    await tester.pumpWidget(const Bai09App());
    await tester.tap(find.text('Bài 2. Đăng nhập và đăng ký'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập email.'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'invalid');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.enterText(find.byType(TextFormField).at(2), 'different');
    await tester.ensureVisible(find.text('Đăng ký'));
    await tester.tap(find.text('Đăng ký'));
    await tester.pumpAndSettle();
    expect(find.text('Email không đúng định dạng.'), findsOneWidget);
    expect(find.text('Mật khẩu xác nhận không khớp.'), findsOneWidget);
  });

  testWidgets('Khoản chi kiểm tra nội dung và tiền trước khi lưu', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ExpenseFormScreen(controller: ExpenseController())),
    );
    await tester.enterText(find.byType(TextFormField).at(1), '-5000');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập nội dung chi tiêu.'), findsOneWidget);
    expect(
      find.text('Nhập số nguyên từ 1 đến 999999999999 đồng.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 568),
    const Size(412, 915),
    const Size(800, 600),
    const Size(1024, 768),
  ]) {
    testWidgets('Biểu mẫu cuộn được, không tràn ở $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final screen in <Widget>[
        const LoginScreen(),
        RegisterScreen(controller: AuthController()),
        ExpenseFormScreen(controller: ExpenseController()),
      ]) {
        await tester.pumpWidget(MaterialApp(home: screen));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.showKeyboard(find.byType(TextFormField).first);
        tester.view.viewInsets = const FakeViewPadding(bottom: 250);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        tester.view.resetViewInsets();
        await tester.pumpWidget(const SizedBox());
      }
    });
  }
}
