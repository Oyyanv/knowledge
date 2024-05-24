// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge/db_helper.dart';
import 'package:knowledge/formatuang.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final dbHelper = DBHelper();
  final _formKeySubject = GlobalKey<FormState>();
  final _formKeyCategory = GlobalKey<FormState>();
  final _mapelController = TextEditingController();
  final _kategorikelasController = TextEditingController();
  final _hargaController = TextEditingController();
  final _namamapel = TextEditingController();
  final _kelas = TextEditingController();
  final _inputgambar = TextEditingController();
  String? _selectedmapel;
  String? _selectedkelas;

  List<Map<String, dynamic>> _mapel = [];
  List<Map<String, dynamic>> _kategori = [];

  @override
  void initState() {
    super.initState();
    _refreshMapel();
    _refreshKategori();
  }

  //buat kategori mapel

  void _refreshMapel() async {
    final data = await dbHelper.queryAllMapel();
    setState(() {
      _mapel = data;
    });
  }

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
                            labelText: 'Choose Class',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Require Class';
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
                      labelText: 'Class',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Class';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _inputgambar,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Image URL';
                      }
                      return null;
                    },
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
    // Cek apakah kelas sudah ada
    final existingCategory = _kategori.firstWhere(
      (category) => category['kelas'] == _kelas.text,
      //id_kategori = 1 maksudnya kalo gk ditemukan atau bisa aja kmu sebut null
      orElse: () => {'id_kategori': -1},
    );

    if (existingCategory != null) {
      // kalo kelasnya sudah ada nih, jadi updatenya cuman mapel saja gitu
      await dbHelper.updateKategoriMapel({
        'id_kategori': existingCategory['id_kategori'],
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
        'gambar': _inputgambar.text,
      });
    } else {
      // kalo kelasnya gada buat baru, tapi gak mungkin juga sih kelasnya cuman ada 3
      await dbHelper.insertKategoriMapel({
        'nama_mapel': _namamapel.text,
        'kelas': _kelas.text,
        'gambar': _inputgambar.text,
      });
    }

    _refreshKategori();
  }

  Future<void> _updateKategoriMapel(int id) async {
    await dbHelper.updateKategoriMapel({
      'id_kategori': id,
      'nama_mapel': _namamapel.text,
      'kelas': _kelas.text,
      'gambar': _inputgambar.text,
    });
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
                      top: 10,
                      bottom: 10), // jarak halaman
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
                      top: 10,
                      bottom: 10), // jarak halaman
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButton<String>(
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
