import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show sqfliteFfiInit, databaseFactoryFfi;

class DatabaseHelper {
  DatabaseHelper({this.factory, this.databasePath});
  static final instance = DatabaseHelper();
  final DatabaseFactory? factory;
  final String? databasePath;
  Future<Database>? _opening;
  Future<Database> get database => _opening ??= _open().catchError((Object e) {
    _opening = null;
    throw e;
  });
  Future<Database> _open() async {
    DatabaseFactory factory;
    if (this.factory != null) {
      factory = this.factory!;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      factory = databaseFactoryFfi;
    } else {
      factory = databaseFactory;
    }
    final path =
        databasePath ?? p.join(await factory.getDatabasesPath(), 'buoi9.db');
    return factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT NOT NULL CHECK(length(trim(content)) > 0),
            amount INTEGER NOT NULL CHECK(amount > 0 AND amount <= 999999999999),
            note TEXT NOT NULL DEFAULT ''
          )
        ''');
          await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL COLLATE NOCASE UNIQUE,
            password_hash TEXT NOT NULL,
            password_salt TEXT NOT NULL
          )
        ''');
        },
      ),
    );
  }

  Future<void> close() async {
    final pending = _opening;
    if (pending != null) await (await pending).close();
    _opening = null;
  }
}
