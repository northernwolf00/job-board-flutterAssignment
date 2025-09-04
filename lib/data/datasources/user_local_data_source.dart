import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AuthDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = p.join(await getDatabasesPath(), 'auth.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )''');
      await db.execute('''CREATE TABLE otp(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        code TEXT
      )''');
    });
  }

  static Future<void> insertUser(String email, String password) async {
    final db = await database;
    await db.insert('users', {'email': email, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty ? res.first : null;
  }

  static Future<void> insertOtp(String email, String code) async {
    final db = await database;
    await db.insert('otp', {'email': email, 'code': code},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<bool> verifyOtp(String email, String code) async {
    final db = await database;
    final res =
        await db.query('otp', where: 'email = ? AND code = ?', whereArgs: [email, code]);
    return res.isNotEmpty;
  }
}
