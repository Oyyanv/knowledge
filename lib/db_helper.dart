import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'dart:typed_data';
import 'dart:convert';

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
      version: 3, // Increment the version number
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE mapel(id INTEGER PRIMARY KEY AUTOINCREMENT, mapel TEXT, kategorikelas TEXT, harga TEXT)",
        );
        await db.execute(
          "CREATE TABLE guru(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, gender TEXT, kemampuanmapel TEXT)",
        );
        await db.execute(
          "CREATE TABLE kategori(id INTEGER PRIMARY KEY AUTOINCREMENT, nama_mapel TEXT, kelas TEXT, input_gambar BLOB)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "CREATE TABLE guru(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, gender TEXT, kemampuanmapel TEXT)",
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            "CREATE TABLE kategori(id INTEGER PRIMARY KEY AUTOINCREMENT, nama_mapel TEXT, kelas TEXT, input_gambar BLOB)",
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

  // Convert image file to byte array
  Future<Uint8List> convertImageToByte(String imagePath) async {
    // Load image from file and convert to bytes
    ByteData byteData = await rootBundle.load(imagePath);
    Uint8List bytes = byteData.buffer.asUint8List();
    return bytes;
  }

  // Convert byte array to base64 string
  String convertBytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  // Convert base64 string to byte array
  Uint8List convertBase64ToBytes(String base64String) {
    return base64Decode(base64String);
  }

  // CRUD methods for `kategori` table
  Future<int> insertkategori(Map<String, dynamic> row) async {
    Database db = await database;
    row['input_gambar'] = convertBytesToBase64(row['input_gambar']);
    return await db.insert('kategori', row);
  }

  Future<List<Map<String, dynamic>>> queryAllkategori() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('kategori');
    for (var row in result) {
      row['input_gambar'] = convertBase64ToBytes(row['input_gambar']);
    }
    return result;
  }

  Future<int> updatekategori(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    row['input_gambar'] = convertBytesToBase64(row['input_gambar']);
    return await db.update('kategori', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletekategori(int id) async {
    Database db = await database;
    return await db.delete('kategori', where: 'id = ?', whereArgs: [id]);
  }
}
