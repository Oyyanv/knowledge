import 'package:flutter/services.dart';
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
      version: 5, //versi database sudah ke 5
      //table pertamakali dibikin
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE kategori_mapel("
            "id_kategori INTEGER PRIMARY KEY AUTOINCREMENT, "
            "nama_mapel TEXT, "
            "kelas TEXT, "
            "gambar TEXT)");
        await db.execute("CREATE TABLE mapel("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "id_kategori INTEGER, "
            "mapel TEXT, "
            "kelas TEXT, "
            "gambar TEXT, "
            "harga TEXT, "
            "id_guru INTEGER, "
            "FOREIGN KEY(id_kategori) REFERENCES kategori_mapel(id_kategori), "
            "FOREIGN KEY(id_guru) REFERENCES guru(id))");
        await db.execute("CREATE TABLE guru("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "nama TEXT, "
            "email TEXT, "
            "gender TEXT, "
            "kemampuanmapel TEXT, "
            "gambar_guru TEXT)");
        await db.execute("CREATE TABLE banner("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "gambar_banner TEXT)");
      },
      //onupgrade tablenya itu berarti ada yg di ubah fieldnya atau ada yg nambah table baru
      onUpgrade: (db, oldVersion, newVersion) async {
        //update table pas db versi 2
        //perubahan = + kemampuan mapel
        if (oldVersion < 2) {
          await db.execute("CREATE TABLE guru("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "nama TEXT, "
              "email TEXT, "
              "gender TEXT, "
              "kemampuanmapel TEXT)");
        }
        if (oldVersion < 3) {
          //update table pas db versi 3
          //perubahan = + foreign key guru
          await db.execute("CREATE TABLE kategori_mapel("
              "id_kategori INTEGER PRIMARY KEY AUTOINCREMENT, "
              "nama_mapel TEXT, "
              "kelas TEXT, "
              "gambar TEXT)");
          await db.execute("CREATE TABLE mapel("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "id_kategori INTEGER, "
              "mapel TEXT, "
              "kelas TEXT, "
              "harga TEXT, "
              "id_guru INTEGER, "
              "kemampuan_mapel"
              "FOREIGN KEY(id_guru) REFERENCES guru(id))");
        }
        if (oldVersion < 4) {
          //update table pas db versi 4
          //jika db versi 3 maka field nya tidak berubah
          //perubahan = mengubah tipe data gambar dari BLOB ke TEXT
          await db.execute("CREATE TABLE kategori_mapel("
              "id_kategori INTEGER PRIMARY KEY AUTOINCREMENT, "
              "nama_mapel TEXT, "
              "kelas TEXT, "
              "gambar TEXT)");
        }
        if (oldVersion < 5) {
          //update table versi db 5
          //alter table itu penambahan field untuk guru
          //perubahan = + table baru, + field baru untuk guru
          await db.execute("ALTER TABLE guru ADD COLUMN gambar_guru TEXT");
          await db.execute("CREATE TABLE banner("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "gambar_banner TEXT)");
        }
      },
    );
  }

  // kategori mapel
  Future<int> insertKategoriMapel(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('kategori_mapel', row);
  }

  Future<List<Map<String, dynamic>>> queryAllKategoriMapel() async {
    Database db = await database;
    return await db.query('kategori_mapel');
  }

  Future<int> updateKategoriMapel(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id_kategori'];
    return await db.update('kategori_mapel', row,
        where: 'id_kategori = ?', whereArgs: [id]);
  }

  Future<int> deleteKategoriMapel(int id) async {
    Database db = await database;
    return await db
        .delete('kategori_mapel', where: 'id_kategori = ?', whereArgs: [id]);
  }

  //tambah gambar kategori
  //lalu ubah jadi 8bit
  Future<int> saveImage(Uint8List imageBytes) async {
    Database db = await database;
    return await db.insert('kategori_mapel', {'gambar': imageBytes});
  }

  // ambil image dari database
  Future<Uint8List?> getImage(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('kategori_mapel',
        columns: ['gambar'], where: 'id_kategori = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first['gambar'] as Uint8List?;
    }
    return null;
  }

  // mapel
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

  // guru
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

  //tambah gambar guru
  //lalu ubah jadi 8bit
  Future<int> tambahImage(Uint8List imageBytes) async {
    Database db = await database;
    return await db.insert('guru', {'gambar_guru': imageBytes});
  }

  // ambil image dari database
  Future<Uint8List?> ambilGambar(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('guru',
        columns: ['gambar_guru'], where: 'guru = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first['gambar_guru'] as Uint8List?;
    }
    return null;
  }

  //banner
  Future<int> insertBanner(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('banner', row);
  }

  Future<List<Map<String, dynamic>>> queryAllBanner() async {
    Database db = await database;
    return await db.query('banner');
  }

  Future<int> updateBanner(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('banner', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBanner(int id) async {
    Database db = await database;
    return await db.delete('banner', where: 'id = ?', whereArgs: [id]);
  }

  //tambah gambar banner
  //lalu ubah jadi 8bit
  Future<int> tambahBanner(Uint8List bannerBytes) async {
    Database db = await database;
    return await db.insert('banner', {'gambar_banner': bannerBytes});
  }

  // ambil image dari database
  Future<Uint8List?> ambilBanner(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('banner',
        columns: ['gambar_banner'], where: 'guru = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first['gambar_banner'] as Uint8List?;
    }
    return null;
  }
}
