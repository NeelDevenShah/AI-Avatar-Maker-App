import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join('./users.db');
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
        );
      },
    );
  }

  Future<void> insertUser(String email, String password) async {
    final db = await database;
    print('Inserting user: $email');
    await db.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('User inserted');
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
