import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'MySimpleNote.db');
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,

    );
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql = """
    CREATE TABLE notes (
      note_id INTEGER PRIMARY KEY,
      header TEXT,
      details TEXT,
      created_at TEXT
    );
  """;

    await database.execute(sql);
  }
}
