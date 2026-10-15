import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStore {
  static Future<File> file(String name) async {
    final folder = await getApplicationDocumentsDirectory();
    return File('${folder.path}/$name');
  }

  static Future<void> saveList(
    String name,
    List<Map<String, dynamic>> items,
  ) async {
    final target = await file(name);
    await target.writeAsString(jsonEncode(items));
  }

  static Future<List<Map<String, dynamic>>> readList(String name) async {
    final target = await file(name);
    if (!await target.exists()) return [];
    final contents = await target.readAsString();
    if (contents.trim().isEmpty) return [];
    final decoded = jsonDecode(contents) as List<dynamic>;
    return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }
}
