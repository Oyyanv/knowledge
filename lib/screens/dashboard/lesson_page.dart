// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledge/db_helper.dart';
import 'package:knowledge/formatuang.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final dbHelper = DBHelper();
  //form
  final _formKeySubject = GlobalKey<FormState>();
  final _formKeyCategory = GlobalKey<FormState>();
  final _mapelController = TextEditingController();
  final _kategorikelasController = TextEditingController();
  final _hargaController = TextEditingController();
  final _namamapel = TextEditingController();
  final _kelas = TextEditingController();
  final _inputgambar = TextEditingController();
  //kategori
  String? _selectedmapel;
  String? _selectedkelas;
  //array data
  List<Map<String, dynamic>> _mapel = [];
  List<Map<String, dynamic>> _kategori = [];
  //coba upload gambar #1
  File? _gambar;
  Future _pilihgambar() async {
    final returngambar =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returngambar == null) return;
    setState(() {
      _gambar = File(returngambar.path);
    });
  }

  @override
  void initState() {
    super.initState();
    //memperbarui data tampilan terbaru
    _refreshMapel();
    _refreshKategori();
  }

  void _refreshMapel() async {
    final data = await dbHelper.queryAllMapel();
    setState(() {
      _mapel = data;
    });
  }

  //buat kategori mapel
  void _refreshKategori() async {
    final data = await dbHelper.queryAllKategoriMapel();
    setState(() {
      _kategori = data;
    });
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingMapel = _mapel.firstWhere((element) => element['id'] == id);
      _mapelController.text = existingMapel['mapel'];
      _kategorikelasController.text = existingMapel['kategorikelas'];
      _hargaController.text = existingMapel['harga'];
    } else {
      _mapelController.clear();
      _kategorikelasController.clear();
      _hargaController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 190,
            ),
            child: Form(
              key: _formKeySubject,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Add New Subject',
                    style: TextStyle(
                      color: Color(0xff404080),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _kategori == null
                      ? CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                          value: _selectedmapel,
                          items: _kategori.map((kategori) {
                            return DropdownMenuItem<String>(
                              value: kategori['id_kategori'].toString(),
                              child: Text(kategori['nama_mapel']),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedmapel = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Choose Subject',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Require Subject';
                            }
                            return null;
                          },
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  _kategori == null //jadi kalo gaada kategorinya dia gak muncul
                      ? CircularProgressIndicator() //berhubungan sama yg tadi itu, jadi fungsinya ini buat loading screen untuk jalanin mencari data dari tabel kategori
                      : DropdownButtonFormField<String>(
                          value: _selectedkelas,
                          items: ['X', 'XI', 'XII'].map((kelas) {
                            return DropdownMenuItem<String>(
                              value: kelas,
                              child: Text(kelas),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedkelas = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Choose Grade',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Require Grade';
                            }
                            return null;
                          },
                        ),
                  TextFormField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      Formatuang(),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFormKategori(int? id) {
    if (id != null) {
      final existingKategori =
          _kategori.firstWhere((element) => element['id_kategori'] == id);
      _namamapel.text = existingKategori['nama_mapel'];
      _kelas.text = existingKategori['kelas'];
      _inputgambar.text = existingKategori['gambar'];
    } else {
      _namamapel.clear();
      _kelas.clear();
      _inputgambar.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 190,
            ),
            child: Form(
              key: _formKeyCategory,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Add New Category',
                    style: TextStyle(
                      color: Color(0xff404080),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextFormField(
                    controller: _namamapel,
                    decoration:
                        const InputDecoration(labelText: 'Subject Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Subject Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _kelas.text.isNotEmpty ? _kelas.text : null,
                    items: ['X', 'XI', 'XII']
                        .map((kelas) {
                          return DropdownMenuItem<String>(
                            value: kelas,
                            child: Text(kelas),
                          );
                        })
                        .toSet()
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _kelas.text = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Grade',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Grade';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _pilihgambar,
                        child: Text('Upload Image'),
                      ),
                      if (_gambar != null)
                        Image.file(
                          _gambar!,
                          width: 150,
                          height: 150,
                          //biar jadi kotak
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    child: Text(id == null ? 'Create' : 'Update'),
                    onPressed: () {
                      if (_formKeyCategory.currentState!.validate()) {
                        if (id == null) {
                          _addKategoriMapel();
                        } else {
                          _updateKategoriMapel(id);
                        }
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addMapel() async {
    await dbHelper.insertMapel({
      'mapel': _mapelController.text,
      'kategorikelas': _kategorikelasController.text,
      'harga': _hargaController.text,
    });
    _refreshMapel();
  }

  Future<void> _updateMapel(int id) async {
    await dbHelper.updateMapel({
      'id': id,
      'mapel': _mapelController.text,
      'kategorikelas': _kategorikelasController.text,
      'harga': _hargaController.text,
    });
    _refreshMapel();
  }

  Future<void> _addKategoriMapel() async {
    // Cek apakah ada kategori dengan kelas yang sama
    final existingKategori = _kategori.firstWhere(
      (kategori) => kategori['kelas'] == _kelas.text,
      orElse: () => {'kategori_mapel': -1},
    );

    // Jika kategori dengan kelas yang sama ditemukan
    if (existingKategori != {'kategori_mapel': -1}) {
      // Cek apakah nama mapel sama dengan yang sudah ada
      final sameMapelExists = _kategori.any(
        (kategori) =>
            kategori['nama_mapel'] == _namamapel.text &&
            kategori['kelas'] == _kelas.text,
      );

      // Jika nama mapel juga sama, tampilkan Snackbar
      if (sameMapelExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Category already exists in the database'),
          ),
        );
        return; // Hentikan proses penambahan data baru
      }
    }

    // Jika tidak ada kategori dengan kelas yang sama atau nama mapel berbeda, tambahkan data baru
    if (_gambar != null) {
      //dibaca sebagai byte
      List<int> imageBytes = await _gambar!.readAsBytes();
      //diubah lagi dari byte ke format base64 lalu masuk database
      String base64Image = base64Encode(imageBytes);

      await dbHelper.insertKategoriMapel({
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
        'gambar': base64Image,
      });
    } else {
      await dbHelper.insertKategoriMapel({
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
      });
    }

    _refreshKategori();
  }

  Future<void> _updateKategoriMapel(int id) async {
    // Cek apakah ada kategori dengan kelas yang sama kecuali untuk entri yang sedang diperbarui
    final existingKategori = _kategori.firstWhere(
      (kategori) =>
          kategori['kelas'] == _kelas.text && kategori['id_kategori'] != id,
      orElse: () => {'kategori_mapel': -1},
    );

    // Jika kategori dengan kelas yang sama ditemukan
    if (existingKategori != null) {
      // Cek apakah nama mapel sama dengan yang sudah ada
      final sameMapelExists = _kategori.any(
        (kategori) =>
            kategori['nama_mapel'] == _namamapel.text &&
            kategori['kelas'] == _kelas.text,
      );

      // Jika nama mapel juga sama, tampilkan Snackbar
      if (sameMapelExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category already exists in the database'),
          ),
        );
        return; // Hentikan proses pembaruan data
      }
    }

    // Jika tidak ada kategori dengan kelas yang sama atau nama mapel berbeda, lakukan pembaruan data
    if (_gambar != null) {
      List<int> imageBytes = await _gambar!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await dbHelper.updateKategoriMapel({
        'id_kategori': id,
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
        'gambar': base64Image,
      });
    } else {
      await dbHelper.updateKategoriMapel({
        'id_kategori': id,
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
      });
    }

    _refreshKategori();
  }

  void _deleteMapel(int id) async {
    await dbHelper.deleteMapel(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Subject deleted')));
    _refreshMapel();
  }

  void _deleteKategori(int id) async {
    await dbHelper.deleteKategoriMapel(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Category deleted')));
    _refreshKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff4B4949),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () => _showFormKategori(null),
                  child: Icon(
                    Icons.add,
                    color: Color(0xff4B4949),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _kategori.isNotEmpty,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(10.0), // Atur border radius
                  ),
                  margin: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                    top: 10,
                  ), // jarak halaman
                  padding:
                      EdgeInsets.symmetric(horizontal: 15), // jarak didalam
                  child: DropdownButton<String>(
                    value: _selectedmapel,
                    items: _kategori.map((kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori['id_kategori'].toString(),
                        child: Text(kategori['nama_mapel']),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedmapel = newValue!;
                      });
                    },
                    hint: Text('Choose Subject'),
                    isExpanded:
                        true, //dropdown menampilkan pilihan secara penuh
                    underline: Container(), // Hilangkan garis bawah dropdown
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(10.0), // Atur border radius
                  ),
                  margin: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                    top: 10,
                  ), // jarak halaman
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButton<String>(
                    value: _selectedkelas,
                    items: ['X', 'XI', 'XII'].map((kelas) {
                      return DropdownMenuItem<String>(
                        value: kelas,
                        child: Text(kelas),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedkelas = newValue!;
                      });
                    },
                    hint: Text('Choose Class'),
                    isExpanded:
                        true, //dropdown menampilkan pilihan secara penuh
                    underline: Container(), // Hilangkan garis bawah dropdown
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Subject List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff4B4949),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () => _showForm(null),
                  child: Icon(
                    Icons.add,
                    color: Color(0xff4B4949),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _mapel.isNotEmpty,
            child: Expanded(
              child: ListView(
                children: _mapel.map(
                  (mapel) {
                    return Card(
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        title: Text(mapel['mapel']),
                        subtitle: Text(mapel['kategorikelas']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showForm(mapel['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteMapel(mapel['id']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
