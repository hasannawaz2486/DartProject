import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  DBHelper._internal() {
    // if (_database == null) database;
  }
  static final DBHelper instance = DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'chat_database.db');
    print('Path is = $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the table to store chat messages
        await db.execute('''
          CREATE TABLE chat_messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            message TEXT,
            sender TEXT,
            time INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertMessage(Map<String, dynamic> messageMap) async {
    Database? db = _database;
    await db!.insert('chat_messages', messageMap);
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    Database db = await database;
    return await db.query('chat_messages');
  }
}
