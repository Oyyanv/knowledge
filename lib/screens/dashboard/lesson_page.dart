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
import 'package:knowledge/screens/dashboard/detailMapel/detailmapel_page.dart';

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
  // final _namaGuru = TextEditingController();
  //pilihan kategorinya
  String? _selectedmapel;
  String? _selectedkelas;
  String? _selectedguru;
  //array data table mapel,guru,kategori
  List<Map<String, dynamic>> _mapel = [];
  List<Map<String, dynamic>> _kategori = [];
  List<Map<String, dynamic>> _guru = [];
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
    _refreshGuru();
  }

  //ini untuk manggil data dari table di database
  void _refreshMapel() async {
    final data = await dbHelper.queryAllMapel();
    setState(() {
      _mapel = data;
    });
  }

  void _refreshGuru() async {
    final data = await dbHelper.queryAllGuru();
    setState(() {
      _guru = data;
    });
  }

  //buat kategori mapel
  void _refreshKategori() async {
    final data = await dbHelper.queryAllKategoriMapel();
    setState(() {
      _kategori = data;
    });
  }

  //form tambah mapel
  void _showForm(int? id) {
    if (id != null) {
      final existingMapel = _mapel.firstWhere((element) => element['id'] == id);
      _mapelController.text = existingMapel['mapel'];
      _kategorikelasController.text = existingMapel['kelas'];
      _hargaController.text = existingMapel['harga'];
    } else {
      _mapelController.clear();
      _kategorikelasController.clear();
      _hargaController.clear();
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
                          dropdownColor: Color(0xffFFFFFF),
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
                          dropdownColor: Color(0xffFFFFFF),
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
                  SizedBox(
                    height: 10,
                  ),
                  _guru == null
                      ? CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                          dropdownColor: Color(0xffFFFFFF),
                          value: _selectedguru,
                          items: _guru.map((guru) {
                            return DropdownMenuItem<String>(
                              value: guru['id'].toString(),
                              child: Text(guru['nama']),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedguru = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Choose Teacher',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Require Teacher';
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Require Price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    height: 50,
                    width: 500,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xff6B6BA6)),
                      ),
                      child: Text(
                        id == null ? 'Create' : 'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKeySubject.currentState!.validate()) {
                          if (id == null) {
                            _addMapel();
                          } else {
                            _updateMapel(id);
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

  //form tambah kategori
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
                    dropdownColor: Color(0xffFFFFFF),
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
                    height: 50,
                    width: 500,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xff6B6BA6)),
                      ),
                      child: Text(
                        id == null ? 'Create' : 'Update',
                        style: TextStyle(color: Colors.white),
                      ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //proses tambah mapel
  Future<void> _addMapel() async {
    // Periksa apakah nilai yang dipilih dari dropdown tidak kosong
    if (_selectedmapel == null ||
        _selectedkelas == null ||
        _selectedguru == null) {
      // Tampilkan pesan atau lakukan tindakan yang sesuai jika salah satu nilai kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all fields')),
      );
      return; // Hentikan proses jika salah satu nilai kosong
    }

    // Periksa apakah harga tidak kosong dan valid
    if (_hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the price')),
      );
      return;
    }

    // Dapatkan data mapel dan kelas dari tabel kategori
    final selectedKategori = _kategori.firstWhere(
      (kategori) => kategori['id_kategori'].toString() == _selectedmapel,
      orElse: () => {'id_kategori': -1}, //id_kategori : -1 = null sama aja
    );
    //mapel kelas dan gambar berdasarkan dari tabel nya kategori
    final selectedMapel = selectedKategori['nama_mapel'];
    final selectedKelas = selectedKategori['kelas'];
    final selectedGambar = selectedKategori['gambar'];

    // Dapatkan nama guru dari tabel guru
    final selectedGuru = _guru.firstWhere(
      (guru) => guru['id'].toString() == _selectedguru,
      orElse: () => {'id': -1},
    );

    final namaGuru = selectedGuru['nama'];

    // Insert data ke database
    await dbHelper.insertMapel({
      'mapel': selectedMapel,
      'kelas': selectedKelas,
      'nama_guru': namaGuru,
      'harga': _hargaController.text,
      'gambar': selectedGambar,
    });

    // Perbarui tampilan dengan data terbaru
    _refreshMapel();
  }

  Future<void> _updateMapel(int id) async {
    // Dapatkan data subjek dan kelas dari tabel kategori
    final selectedKategori = _kategori.firstWhere(
      (kategori) => kategori['id_kategori'] == int.parse(_selectedmapel!),
      orElse: () => {'id_kategori': -1},
    );

    final selectedMapel = selectedKategori['nama_mapel'];
    final selectedKelas = selectedKategori['kelas'];
    final selectedGambar = selectedKategori['gambar'];

    // Dapatkan nama guru dari tabel guru
    final selectedGuru = _guru.firstWhere(
      (guru) => guru['id'].toString() == _selectedguru,
      orElse: () => {'id': -1},
    );

    final namaGuru = selectedGuru['nama'];

    await dbHelper.updateMapel({
      'id': id,
      'mapel': selectedMapel,
      'kelas': selectedKelas,
      'nama_guru': namaGuru,
      'harga': _hargaController.text,
      'gambar': selectedGambar,
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
            content: Text('Category already exists in the database'),
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
    // Cek apakah ada kategori dengan kelas yang sama kecuali untuk data yang sedang diperbarui
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

  //nge filter mapelnya
  List<Map<String, dynamic>> _filteredMapel() {
    //nyari di kategori
    final selectedCategory = _kategori.firstWhere(
      (kategori) => kategori['id_kategori'].toString() == _selectedmapel,
      orElse: () => {'nama_mapel': ''},
    );

    //trus di cocokin ke table mapel
    return _mapel.where((mapel) {
      return mapel['mapel'] == selectedCategory['nama_mapel'];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
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
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedmapel = null;
                          _selectedkelas = null;
                        });
                      },
                      child: Icon(
                        Icons.refresh,
                        color: Color(0xff4B4949),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showFormKategori(null),
                      child: Icon(
                        Icons.add,
                        color: Color(0xff4B4949),
                      ),
                    ),
                  ],
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
                    dropdownColor: Color(0xffFFFFFF),
                    value: _selectedmapel,
                    items: _kategori.map((kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori['id_kategori'].toString(),
                        child: Text(kategori['nama_mapel']),
                      );
                    }).toList(),
                    // Panggil fungsi tersebut setiap kali terjadi perubahan pada pilihan kategori
                    onChanged: (newValue) {
                      setState(() {
                        _selectedmapel = newValue!;
                        _filteredMapel();
                        _refreshMapel();
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
                    dropdownColor: Color(0xffFFFFFF),
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
                        _refreshMapel();
                        _filteredMapel();
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
            visible: _selectedmapel != null,
            replacement: Expanded(
              child: ListView(
                children: _mapel.map(
                  (mapel) {
                    return Card(
                      color: Color(0xffF7F7F7),
                      elevation: 8,
                      margin: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailmapelPage(
                                namamapel: mapel['mapel'],
                                namaguru: mapel['nama_guru'],
                                kelas: mapel['kelas'],
                                harga: mapel['harga'],
                                gambar: mapel['gambar'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: mapel['gambar'] != null
                              ? Image.memory(
                                  base64Decode(mapel['gambar']),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.book, size: 50),
                          title: Text(mapel['mapel']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kelas : ${mapel['kelas']}'),
                              Text('Teacher : ${mapel['nama_guru']}'),
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
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            child: Expanded(
              child: ListView(
                children: _filteredMapel().map(
                  (mapel) {
                    return Card(
                      color: Color(0xffF7F7F7),
                      elevation: 8,
                      margin: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman detail mapel
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailmapelPage(
                                namamapel: mapel['mapel'],
                                namaguru: mapel['nama_guru'],
                                kelas: mapel['kelas'],
                                harga: mapel['harga'],
                                gambar: mapel['gambar'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: mapel['gambar'] != null
                              ? Image.memory(
                                  base64Decode(mapel['gambar']),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.book, size: 50),
                          title: Text(mapel['mapel']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kelas : ${mapel['kelas']}'),
                              Text('Teacher : ${mapel['nama_guru']}'),
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
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
