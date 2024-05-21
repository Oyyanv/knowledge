import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'crud.db');
    return await openDatabase(
      path,
      version: 2, 
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE mapel(id INTEGER PRIMARY KEY AUTOINCREMENT, mapel TEXT, kategorikelas TEXT, harga TEXT)",
        );
        await db.execute(
          "CREATE TABLE guru(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, gender TEXT, kemampuanmapel TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "CREATE TABLE guru(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, gender TEXT, kemampuanmapel TEXT)",
          );
        }
      },
    );
  }

  // CRUD methods for `mapel` table
  Future<int> insertMapel(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('mapel', row);
  }

  Future<List<Map<String, dynamic>>> queryAllMapel() async {
    Database db = await database;
    return await db.query('mapel');
  }

  Future<int> updateMapel(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('mapel', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMapel(int id) async {
    Database db = await database;
    return await db.delete('mapel', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD methods for `guru` table
  Future<int> insertGuru(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('guru', row);
  }

  Future<List<Map<String, dynamic>>> queryAllGuru() async {
    Database db = await database;
    return await db.query('guru');
  }

  Future<int> updateGuru(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('guru', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteGuru(int id) async {
    Database db = await database;
    return await db.delete('guru', where: 'id = ?', whereArgs: [id]);
  }
}