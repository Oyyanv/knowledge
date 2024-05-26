import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'db_helper.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Banner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BannerPage(),
    );
  }
}

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

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
      final existingBanner = _banners.firstWhere((element) => element['id'] == id);
      _selectedImage = existingBanner['gambar_banner'];
    } else {
      _selectedImage = null;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedImage != null)
                Image.memory(_selectedImage!, height: 150),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Gambar'),
                  ),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pilih Gambar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Banner deleted')));
    _refreshBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Banner with SQLite'),
      ),
      body: ListView.builder(
        itemCount: _banners.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text('Banner ${_banners[index]['id']}'),
            subtitle: _banners[index]['gambar_banner'] != null
                ? Image.memory(_banners[index]['gambar_banner'], height: 100)
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
                    onPressed: () => _deleteBanner(_banners[index]['id']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
