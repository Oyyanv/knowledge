// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledge/db_helper.dart';
// import 'package:knowledge/screens/home.dart';

class Tablekategori extends StatefulWidget {
  const Tablekategori({super.key});

  @override
  State<Tablekategori> createState() => _TablekategoriState();
}

class _TablekategoriState extends State<Tablekategori> {
  //database
  final dbHelper = DBHelper();
  final _formKeyKategori = GlobalKey<FormState>();
  final _namamapel = TextEditingController();
  final _inputgambar = TextEditingController();

  //gambar
  File? _gambar;
  Future _pilihgambar() async {
    final returngambar =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returngambar == null) return;
    setState(() {
      _gambar = File(returngambar.path);
    });
  }

  //data db
  List<Map<String, dynamic>> _kategori = [];

  @override
  void initState() {
    super.initState();
    //refresh tampilan data
    _refreshKategori();
  }

  void _refreshKategori() async {
    final data = await dbHelper.queryAllKategoriMapel();
    setState(() {
      _kategori = data;
    });
  }

  void _showFormKategori(int? id) {
    if (id != null) {
      final existingKategori =
          _kategori.firstWhere((element) => element['id_kategori'] == id);
      _namamapel.text = existingKategori['nama_mapel'];
      _inputgambar.text = existingKategori['gambar'];
    } else {
      _namamapel.clear();
      _inputgambar.clear();
    }

    showModalBottomSheet(
      backgroundColor: Color(0xffFFFFFF),
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
              key: _formKeyKategori,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Edit New Category',
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color(0xff6B6BA6),
                          ),
                        ),
                        onPressed: _pilihgambar,
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                          ),
                        ),
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
                  SizedBox(
                    width: 500,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xff6B6BA6),
                        ),
                      ),
                      child: Text(
                        id == null ? 'Create' : 'Update',
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                      onPressed: () {
                        if (_formKeyKategori.currentState!.validate()) {
                          if (id == null) {
                            // _addKategoriMapel();
                          } else {
                            _updateKategoriMapel(id);
                          }
                          Navigator.of(context).pop();
                        }
                      },
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

  Future<void> _updateKategoriMapel(int id) async {
    // Cek apakah ada kategori dengan kelas yang sama kecuali untuk entri yang sedang diperbarui
    _kategori.firstWhere(
      (kategori) =>
          kategori['nama_mapel'] == _namamapel.text &&
          kategori['id_kategori'] != id,
      orElse: () => {'kategori_mapel': -1},
    );

    // Jika tidak ada kategori dengan kelas yang sama atau nama mapel berbeda, lakukan pembaruan data
    if (_gambar != null) {
      List<int> imageBytes = await _gambar!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await dbHelper.updateKategoriMapel({
        'id_kategori': id,
        'nama_mapel': _namamapel.text,
        'gambar': base64Image,
      });
    } else {
      await dbHelper.updateKategoriMapel({
        'id_kategori': id,
        'nama_mapel': _namamapel.text,
      });
    }

    _refreshKategori();
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
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(right: 64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/images/logonnew.png',
                width: 34,
                height: 34,
              ),
              const Text(
                ' Knowledge',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF404080),
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFFCCD4F0),
                Color(0xFFA4B6E1),
                Color(0xFF9BAAD2)
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Category List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
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
                      color: const Color(0xffF7F7F7),
                      elevation: 6,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: kategori['gambar'] != null
                            ? Image.memory(
                                base64Decode(kategori['gambar']),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person, size: 50),
                        title: Text(kategori['nama_mapel']),
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
        ],
      ),
    );
  }
}
