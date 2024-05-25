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
  //coba upload gambar #1 berhasil wkwkwkw
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
                          items: _kategori.map((kategori) {
                            return DropdownMenuItem<String>(
                              value: kategori['id_kategori'].toString(),
                              child: Text(kategori['kelas']),
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
                  TextButton(
                    onPressed: _pilihgambar,
                    child: Text('Upload Image'),
                  ),
                  if (_gambar != null)
                    Image.file(
                      _gambar!,
                      width: 100,
                      height: 100,
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
    if (_gambar != null) {
      // Membaca gambar sebagai byte array
      List<int> imageBytes = await _gambar!.readAsBytes();
      // Mengonversi byte array menjadi string base64
      String base64Image = base64Encode(imageBytes);

      // Menyimpan entri ke dalam database, termasuk string base64 dari gambar
      await dbHelper.insertKategoriMapel({
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
        'gambar': base64Image, // Menyimpan gambar sebagai string base64
      });
    } else {
      // Jika gambar tidak dipilih, simpan entri tanpa gambar
      await dbHelper.insertKategoriMapel({
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
      });
    }

    _refreshKategori();
  }

  Future<void> _updateKategoriMapel(int id) async {
    if (_gambar != null) {
      // Membaca gambar sebagai byte array
      List<int> imageBytes = await _gambar!.readAsBytes();
      // Mengonversi byte array menjadi string base64
      String base64Image = base64Encode(imageBytes);

      // Memperbarui entri di database, termasuk string base64 dari gambar
      await dbHelper.updateKategoriMapel({
        'id_kategori': id,
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
        'gambar': base64Image, // Menyimpan gambar sebagai string base64
      });
    } else {
      // Jika gambar tidak dipilih, hanya memperbarui entri tanpa gambar
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
                  'Category List',
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
            child: Expanded(
              child: ListView(
                children: _kategori.map(
                  (kategori) {
                    return Card(
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        title: Text(kategori['nama_mapel']),
                        subtitle: Text(kategori['kelas']),
                        leading: kategori['gambar'] != null &&
                                kategori['gambar'] != ''
                            ? Image.memory(
                                base64Decode(kategori['gambar']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.person, size: 50),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showFormKategori(kategori['id_kategori']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteKategori(kategori['id_kategori']),
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
