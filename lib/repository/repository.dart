
import 'package:MySimpleNote/database_helper/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository{
  late DatabaseConnection _databaseConnection;
  Repository(){
    _databaseConnection =DatabaseConnection();
  }
  static Database? _database;
  Future<Database?>get database async{
    if (_database != null){
      return _database;
    }else{
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  insertData(table,data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  readData(table)async{
    var connection = await database;
    return await connection?.query(table);
  }

  readDataByTitle(table, String title) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'header = ?',
      whereArgs: [title],
    );
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection?.update(table, data, where: 'note_id=?', whereArgs: [data['note_id']]);
  }

  deleteDataById(table ,itemId)async{
    var connection = await database;
    return await connection?.rawDelete("delete from $table where note_id=$itemId");
  }
}