import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_user.dart';
import '../utils/database_helper.dart';
import '../utils/validators.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

class AuthController {
  AuthController({DatabaseHelper? database})
    : _helper = database ?? DatabaseHelper.instance;
  final DatabaseHelper _helper;
  // PBKDF2-HMAC-SHA256 với salt ngẫu nhiên riêng cho từng tài khoản.
  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 210000,
    bits: 256,
  );
  Future<String> _hash(String password, List<int> salt) async {
    final key = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    return base64Encode(await key.extractBytes());
  }

  Future<void> register(String email, String password) async {
    final error = Validators.email(email) ?? Validators.password(password);
    if (error != null) throw AuthException(error);
    final db = await _helper.database;
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final hash = await _hash(password, salt);
    try {
      await db.insert('users', {
        'email': email.trim().toLowerCase(),
        'password_hash': hash,
        'password_salt': base64Encode(salt),
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const AuthException('Email đã được đăng ký. Hãy chọn Sign in.');
      }
      rethrow;
    }
  }

  Future<AppUser> signIn(String email, String password) async {
    final db = await _helper.database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      final row = rows.single;
      final actual = base64Decode(
        await _hash(password, base64Decode(row['password_salt'] as String)),
      );
      final expected = base64Decode(row['password_hash'] as String);
      var difference = actual.length ^ expected.length;
      for (var i = 0; i < min(actual.length, expected.length); i++) {
        difference |= actual[i] ^ expected[i];
      }
      if (difference == 0) return AppUser.fromMap(row);
    }
    throw const AuthException('Email hoặc mật khẩu không đúng.');
  }
}
