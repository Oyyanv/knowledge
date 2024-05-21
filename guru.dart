import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Mapel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Guru(title: 'Flutter Demo Home Page'),
    );
  }
}

class Guru extends StatefulWidget {
  const Guru({super.key, required String title});

  @override
  State<Guru> createState() => _GuruState();
}

class _GuruState extends State<Guru> {

  final DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _kemampuanmapelController = TextEditingController();

  List<Map<String, dynamic>> _guru = [];

  @override
  
  void initState() {
    super.initState();
    _refreshGuru();
  }

  void _refreshGuru() async {
    final data = await dbHelper.queryAllGuru();
    setState(() {
      _guru = data;
    });
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingGuru = _guru.firstWhere((element) => element['id'] == id);
      _namaController.text = existingGuru['nama'];
      _emailController.text = existingGuru['email'];
      _genderController.text = existingGuru['gender'];
      _kemampuanmapelController.text = existingGuru['kemampuanmapel'];
    }else{
      _namaController.clear();
      _emailController.clear();
      _genderController.clear();
      _kemampuanmapelController.clear();
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
                controller: _namaController,
                decoration: const InputDecoration(labelText:'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText:'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText:'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kemampuanmapelController,
                decoration: const InputDecoration(labelText:'Kemampuan Mapel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kemampuan mapel';
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
                      _addGuru();
                    }else{
                      _updateGuru(id);
                    }
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      )); 
    }

    Future<void> _addGuru() async {
      await dbHelper.insertGuru({
        'nama':_namaController.text,
        'email':_emailController.text,
        'gender':_genderController.text,
        'kemampuanmapel':_kemampuanmapelController.text,
        
      });
      _refreshGuru();
    }

    Future<void> _updateGuru(int id) async {
      await dbHelper.updateGuru({
        'id':id,
        'nama':_namaController.text,
        'email':_emailController.text,
        'gender':_genderController.text,
        'kemampuanmapel':_kemampuanmapelController.text,
      });
      _refreshGuru();
    }

    void _deleteGuru(int id) async {
      await dbHelper.deleteGuru(id);
      ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Guru deleted')));
      _refreshGuru();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter CRUD with SQLite'),
        ),
        body: ListView.builder(
          itemCount: _guru.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(_guru[index]['nama']),
              subtitle: Text(_guru[index]['email']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_guru[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteGuru(_guru[index]['id']),
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
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }
}