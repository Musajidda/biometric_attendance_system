import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'attendance.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)",
        );
        await db.execute(
          "CREATE TABLE attendance(id INTEGER PRIMARY KEY, userId INTEGER, timestamp TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db!.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db!.query('users');
  }

  Future<void> logAttendance(int userId) async {
    final db = await database;
    await db!.insert('attendance', {
      'userId': userId,
      'timestamp': DateTime.now().toIso8601String()
    });
  }

  Future<int> getAttendanceCount(int userId) async {
    final db = await database;
    var result = await db!.rawQuery('SELECT COUNT(*) FROM attendance WHERE userId = ?', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
