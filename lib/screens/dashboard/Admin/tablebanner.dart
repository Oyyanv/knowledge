// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:knowledge/db_helper.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:knowledge/screens/home.dart';

class BannerPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const BannerPage({Key? key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  final DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _selectedImage;

  List<Map<String, dynamic>> _banners = [];

  @override
  void initState() {
    super.initState();
    _refreshBanners();
  }

  void _refreshBanners() async {
    final data = await dbHelper.queryAllBanner();
    setState(() {
      _banners = data;
    });
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingBanner =
          _banners.firstWhere((element) => element['id'] == id);
      _selectedImage = existingBanner['gambar_banner'];
    } else {
      _selectedImage = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Menjadikan bottom sheet dapat digulir
      elevation: 5,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 190,
        ),
        child: SingleChildScrollView(
          // Menambahkan SingleChildScrollView agar konten dapat digulir
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedImage != null)
                    Image.memory(
                      _selectedImage!,
                      width: 200,
                      height: 150,
                      fit: BoxFit
                          .cover, // untuk memastikan gambar tidak terlalu besar
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Image'),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Pick Image'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    child: Text(id == null ? 'Create' : 'Update'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (id == null) {
                          _addBanner();
                        } else {
                          _updateBanner(id);
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  Future<void> _addBanner() async {
    if (_selectedImage != null) {
      await dbHelper.tambahBanner(_selectedImage!);
      _refreshBanners();
    }
  }

  Future<void> _updateBanner(int id) async {
    if (_selectedImage != null) {
      await dbHelper.updateBanner({'id': id, 'gambar_banner': _selectedImage});
      _refreshBanners();
    }
  }

  void _deleteBanner(int id) async {
    await dbHelper.deleteBanner(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Banner deleted')));
    _refreshBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }));
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
                  'Banner List',
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
                    _showForm(null);
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
            visible: _banners.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                itemCount: _banners.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Banner ${_banners[index]['id']}'),
                        ],
                      ),
                      subtitle: _banners[index]['gambar_banner'] != null
                          ? Image.memory(
                              _banners[index]['gambar_banner'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : null,
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showForm(_banners[index]['id']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteBanner(_banners[index]['id']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
