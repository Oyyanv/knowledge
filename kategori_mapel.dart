import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Kategori Mapel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KategoriMapelPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class KategoriMapelPage extends StatefulWidget {
  const KategoriMapelPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _KategoriMapelPageState createState() => _KategoriMapelPageState();
}

class _KategoriMapelPageState extends State<KategoriMapelPage> {
  final DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  final _mapelController = TextEditingController();
  final _namaKategoriController = TextEditingController();

  List<Map<String, dynamic>> _kategoriMapel = [];

  @override
  void initState() {
    super.initState();
    _refreshKategoriMapel();
  }

  void _refreshKategoriMapel() async {
    final data = await dbHelper.queryAllKategoriMapel();
    setState(() {
      _kategoriMapel = data;
    });
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingKategoriMapel = _kategoriMapel.firstWhere((element) => element['id_kategori'] == id);
      _mapelController.text = existingKategoriMapel['mapel'];
      _namaKategoriController.text = existingKategoriMapel['nama_kategori'];
    } else {
      _mapelController.clear();
      _namaKategoriController.clear();
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
              TextFormField(
                controller: _mapelController,
                decoration: const InputDecoration(labelText: 'Mapel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan mapel';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaKategoriController,
                decoration: const InputDecoration(labelText: 'Nama Kategori'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama kategori';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(id == null ? 'Create' : 'Update'),
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    if (id == null){
                      _addKategoriMapel();
                    } else {
                      _updateKategoriMapel(id);
                    }
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addKategoriMapel() async {
    await dbHelper.insertKategoriMapel({
      'mapel': _mapelController.text,
      'nama_kategori': _namaKategoriController.text,
    });
    _refreshKategoriMapel();
  }

  Future<void> _updateKategoriMapel(int id) async {
    await dbHelper.updateKategoriMapel({
      'id_kategori': id,
      'mapel': _mapelController.text,
      'nama_kategori': _namaKategoriController.text,
    });
    _refreshKategoriMapel();
  }

  void _deleteKategoriMapel(int id) async {
    await dbHelper.deleteKategoriMapel(id);
    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(content: Text('Kategori Mapel terhapus')));
    _refreshKategoriMapel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _kategoriMapel.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(_kategoriMapel[index]['mapel']),
              subtitle: Text(_kategoriMapel[index]['nama_kategori']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_kategoriMapel[index]['id_kategori']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteKategoriMapel(_kategoriMapel[index]['id_kategori']),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
