// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:knowledge/db_helper.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  final _mapelController = TextEditingController();
  final _kategorikelasController = TextEditingController();
  final _hargaController = TextEditingController();
  final _namamapel = TextEditingController();
  final _kelas = TextEditingController();
  final _inputgambar = TextEditingController();

  List<Map<String, dynamic>> _mapel = [];
  List<Map<String, dynamic>> _kategori = [];

  @override
  void initState() {
    super.initState();
    _refreshMapel();
    _kategorimk();
  }

  void _refreshMapel() async {
    final data = await dbHelper.queryAllMapel();
    setState(() {
      _mapel = data;
    });
  }

  void _kategorimk() async {
    final data = await dbHelper.queryAllMapel();
    setState(() {
      _kategori = data;
    });
  }

//form tambah subject
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
              key: _formKey,
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
                  TextFormField(
                    controller: _mapelController,
                    decoration: const InputDecoration(labelText: 'Subject'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Name Subject';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _kategorikelasController,
                    decoration: const InputDecoration(labelText: 'Class'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Category Class';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _hargaController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    child: Text(id == null ? 'Create' : 'Update'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (id == null) {
                          _addMapel();
                        } else {
                          _updateMapel(id);
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

  //form tambah kategori
  void _showformkategori(int? id) {
    if (id != null) {
      final exitingKategori =
          _kategori.firstWhere((element) => element['id'] == id);
      _namamapel.text = exitingKategori['nama_mapel'];
      _kelas.text = exitingKategori['kelas'];
      _inputgambar.text = exitingKategori['input_gambar'];
    }

    
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

  void _deleteMapel(int id) async {
    await dbHelper.deleteMapel(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Mapel deleted')));
    _refreshMapel();
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
          //ini kalo data mapelnya kosong jadi text dan button tambah nya gak ikutan ilang
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
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      mapel['kategorikelas'],
                                    ),
                                    Text(
                                      mapel['harga'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
