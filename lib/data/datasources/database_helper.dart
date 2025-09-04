import 'package:interviews_flutter_assignment/data/models/application.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'jobs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE applications (
        id TEXT PRIMARY KEY,
        jobId TEXT NOT NULL,
        candidateName TEXT NOT NULL,
        candidateEmail TEXT NOT NULL,
        candidatePhone TEXT NOT NULL,
        cvPath TEXT NOT NULL,
        appliedAt TEXT NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insertApplication(Application application) async {
    final db = await database;
    await db.insert(
      'applications',
      application.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Application>> getApplications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('applications');
    return List.generate(maps.length, (i) => Application.fromJson(maps[i]));
  }

  Future<List<Application>> getApplicationsByJobId(String jobId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'applications',
      where: 'jobId = ?',
      whereArgs: [jobId],
    );
    return List.generate(maps.length, (i) => Application.fromJson(maps[i]));
  }

  Future<void> updateApplicationSyncStatus(String id, bool synced) async {
    final db = await database;
    await db.update(
      'applications',
      {'synced': synced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Application>> getUnsyncedApplications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'applications',
      where: 'synced = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => Application.fromJson(maps[i]));
  }
}