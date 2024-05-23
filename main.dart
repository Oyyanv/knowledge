import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'kategori_mapel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD with SQLite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  final _kategoriController = TextEditingController();
  String _selectedKelas = 'Kelas X'; // Default value
  final _hargaController = TextEditingController();

  List<Map<String, dynamic>> _mapel = [];
  List<Map<String, dynamic>> _kategoriMapel = [];

  @override
  void initState() {
    super.initState();
    _refreshMapel();
    _refreshKategoriMapel();
  }

  void _refreshMapel() async {
    final data = await dbHelper.queryAllMapel();
    setState(() {
      _mapel = data;
    });
  }

  void _refreshKategoriMapel() async {
    final data = await dbHelper.queryAllKategoriMapel();
    setState(() {
      _kategoriMapel = data;
    });
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingMapel = _mapel.firstWhere((element) => element['id'] == id);
      _kategoriController.text = existingMapel['id_kategori'].toString();
      _selectedKelas = existingMapel['kategori_kelas'];
      _hargaController.text = existingMapel['harga'];
    } else {
      _kategoriController.clear();
      _selectedKelas = 'X'; 
      _hargaController.clear();
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
              DropdownButtonFormField<int>(
                value: id != null ? int.tryParse(_kategoriController.text) : null,
                items: _kategoriMapel.map((kategori) {
                  return DropdownMenuItem<int>(
                    value: kategori['id_kategori'],
                    child: Text(kategori['mapel']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _kategoriController.text = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: 'Mapel'),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih mapel';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedKelas,
                items: <String>['X', 'XI', 'XII']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKelas = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kategori Kelas'),
              ),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addMapel() async {
    await dbHelper.insertMapel({
      'id_kategori': int.parse(_kategoriController.text),
      'kategori_kelas': _selectedKelas,
      'mapel': _kategoriMapel.firstWhere((kategori) => kategori['id_kategori'] == int.parse(_kategoriController.text))['mapel'],
      'harga': _hargaController.text,
    });
    _refreshMapel();
  }

  Future<void> _updateMapel(int id) async {
    await dbHelper.updateMapel({
      'id': id,
      'id_kategori': int.parse(_kategoriController.text),
      'kategori_kelas': _selectedKelas,
      'mapel': _kategoriMapel.firstWhere((kategori) => kategori['id_kategori'] == int.parse(_kategoriController.text))['mapel'],
      'harga': _hargaController.text,
    });
    _refreshMapel();
  }

  void _deleteMapel(int id) async {
    await dbHelper.deleteMapel(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mapel terhapus')));
    _refreshMapel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD with SQLite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const KategoriMapelPage(title: '',),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _mapel.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(
              '${_kategoriMapel.firstWhere((kategori) => kategori['id_kategori'] == _mapel[index]['id_kategori'])['mapel']} - ${_mapel[index]['kategori_kelas']}',
            ),
            subtitle: Text(
              'Harga: ${_mapel[index]['harga']}',
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showForm(_mapel[index]['id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteMapel(_mapel[index]['id']),
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
