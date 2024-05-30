// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledge/db_helper.dart';
// import 'package:knowledge/screens/home.dart';

class Tableguru extends StatefulWidget {
  const Tableguru({Key? key}) : super(key: key);

  @override
  State<Tableguru> createState() => _TableguruState();
}

class _TableguruState extends State<Tableguru> {
  //manggil db
  final dbHelper = DBHelper();
  //form
  final _formKeyGuru = GlobalKey<FormState>();
  final _namaguruController = TextEditingController();
  final _emailGuruController = TextEditingController();
  final _genderGuruController = TextEditingController();
  final _kemampuanGuruController = TextEditingController();
  final _gambarGuruController = TextEditingController();
  //gender
  String? genderGuru;
  //array data guru dari db
  List<Map<String, dynamic>> _guru = [];

  File? _profileGuru;
  //memunculkan drive memilih gambar
  Future _pilihimg() async {
    final returnimg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnimg == null) return;
    setState(() {
      _profileGuru = File(returnimg.path);
    });
  }

  @override
  void initState() {
    super.initState();
    //memperbarui tampilan data terbaru
    _refreshGuru();
  }

  void _refreshGuru() async {
    final data = await dbHelper.queryAllGuru();
    setState(() {
      _guru = data;
    });
  }

  void _showformGuru(int? id) {
    //kalo null berarti nambah data, tpi klo gak null berarti sedang edit data
    if (id != null) {
      final existingGuru = _guru.firstWhere((element) => element['id'] == id);
      _namaguruController.text = existingGuru['nama'];
      _emailGuruController.text = existingGuru['email'];
      _genderGuruController.text = existingGuru['gender'];
      _kemampuanGuruController.text = existingGuru['kemampuanmapel'];
      _gambarGuruController.text = existingGuru['gambar_guru'];
    } else {
      //menerima inputan kosong
      _namaguruController.clear();
      _emailGuruController.clear();
      _genderGuruController.clear();
      _kemampuanGuruController.clear();
      _gambarGuruController.clear();
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Form(
              key: _formKeyGuru,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Add New Teacher',
                    style: TextStyle(
                      color: Color(0xff404080),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextFormField(
                    controller: _namaguruController,
                    decoration: const InputDecoration(
                        hintText: 'Name', prefixIcon: Icon(Icons.person)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailGuruController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Require Email';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Email Not Valid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _kemampuanGuruController,
                    decoration: InputDecoration(
                      hintText: 'Skill Subject',
                      prefixIcon: Icon(Icons.all_inbox_sharp),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Skill Subject';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    dropdownColor: Color(0xffFFFFFF),
                    value: _genderGuruController.text.isNotEmpty
                        ? _genderGuruController.text
                        : null,
                    items: ['Man', 'Woman']
                        .map((gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        })
                        .toSet()
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _genderGuruController.text = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Gender';
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
                        onPressed: _pilihimg,
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                      ),
                      if (_profileGuru != null)
                        Image.file(
                          _profileGuru!,
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
                        id == null ? 'Add' : 'Update',
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                      onPressed: () {
                        if (_formKeyGuru.currentState!.validate()) {
                          if (id == null) {
                            _addGuru();
                          } else {
                            _updateGuru(id);
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

  Future<void> _addGuru() async {
    if (_profileGuru != null) {
      //dibaca byte
      List<int> imgByte = await _profileGuru!.readAsBytes();
      //diubah lagi jadi base64
      String base64Img = base64Encode(imgByte);
      await dbHelper.insertGuru({
        'nama': _namaguruController.text,
        'email': _emailGuruController.text,
        'kemampuanmapel': _kemampuanGuruController.text,
        'gender': _genderGuruController.text,
        'gambar_guru': base64Img,
      });
    } else {
      //kalo gambar gk di input
      await dbHelper.insertGuru({
        'nama': _namaguruController.text,
        'email': _emailGuruController.text,
        'kemampuanmapel': _kemampuanGuruController.text,
        'gender': _genderGuruController.text,
      });
    }
    _refreshGuru();
  }

  Future<void> _updateGuru(int id) async {
    if (_profileGuru != null) {
      //dibaca byte
      List<int> imgByte = await _profileGuru!.readAsBytes();
      //diubah lagi jadi base64
      String base64Img = base64Encode(imgByte);
      await dbHelper.updateGuru({
        'id': id,
        'nama': _namaguruController.text,
        'email': _emailGuruController.text,
        'kemampuanmapel': _kemampuanGuruController.text,
        'gender': _genderGuruController.text,
        'gambar_guru': base64Img,
      });
    } else {
      //kalo gambar gk di input
      await dbHelper.updateGuru({
        'id': id,
        'nama': _namaguruController.text,
        'email': _emailGuruController.text,
        'kemampuanmapel': _kemampuanGuruController.text,
        'gender': _genderGuruController.text,
      });
    }
    _refreshGuru();
  }

  void _deleteGuru(int id) async {
    await dbHelper.deleteGuru(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Data deleted')));
    _refreshGuru();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: Container(
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
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                Color(0xFFCCD4F0),
                Color(0xFFA4B6E1),
                Color(0xFF9BAAD2)
              ])),
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
                  'Teacher List',
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
                  onPressed: () {
                    _showformGuru(null);
                  },
                  child: Icon(
                    Icons.add,
                    color: Color(0xff4B4949),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _guru.isNotEmpty,
            child: Expanded(
              child: ListView(
                children: _guru.map(
                  (guru) {
                    return Card(
                      color: const Color(0xffF7F7F7),
                      elevation: 6,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: guru['gambar_guru'] != null
                            ? Image.memory(
                                base64Decode(guru['gambar_guru']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person, size: 50),
                        title: Text(guru['nama']),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  guru['gender'],
                                ),
                                Text(guru['kemampuanmapel']),
                                Text(guru['email']),
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
                                onPressed: () => _showformGuru(guru['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteGuru(guru['id']),
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
