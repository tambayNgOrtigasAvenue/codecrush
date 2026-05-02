import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'player_progress.dart';

class DatabaseHelper {
  static const _databaseName = "PlayerProgress.db";
  static const _databaseVersion = 1;

  static const tableProgress = 'player_progress';

  static const columnId = 'id';
  static const columnLessonId = 'lesson_id';
  static const columnScore = 'score';
  static const columnIsCompleted = 'is_completed';
  static const columnUpdatedAt = 'updated_at';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableProgress (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnLessonId TEXT NOT NULL UNIQUE,
            $columnScore INTEGER DEFAULT 0,
            $columnIsCompleted INTEGER DEFAULT 0,
            $columnUpdatedAt INTEGER
          )
          ''');
  }

  // Helper methods

  Future<int> insertOrUpdateProgress(PlayerProgress progress) async {
    Database db = await instance.database;
    return await db.insert(
      tableProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PlayerProgress?> getProgress(String lessonId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableProgress,
      where: '$columnLessonId = ?',
      whereArgs: [lessonId],
    );

    if (maps.isNotEmpty) {
      return PlayerProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<List<PlayerProgress>> getAllProgress() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableProgress);
    return List.generate(maps.length, (i) {
      return PlayerProgress.fromMap(maps[i]);
    });
  }

  Future<int> deleteProgress(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableProgress,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
