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
  
  List<Map<String, dynamic>> _mapel = [];

  @override
  
  void initState() {
    super.initState();
    _refreshMapel();
  }

  void _refreshMapel() async {
    final data = await dbHelper.queryAllMapel();
    setState(() {
      _mapel = data;
    });
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingMapel = _mapel.firstWhere((element) => element['id'] == id);
      _mapelController.text = existingMapel['mapel'];
      _kategorikelasController.text = existingMapel['kategorikelas'];
      _hargaController.text = existingMapel['harga'];
    }else{
      _mapelController.clear();
      _kategorikelasController.clear();
      _hargaController.clear();
    }

    showModalBottomSheet(
      context: context,
      elevation: 10,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                controller: _mapelController,
                decoration: const InputDecoration(labelText:'Mapel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan mapel';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kategorikelasController,
                decoration: const InputDecoration(labelText:'Kategori Kelas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kategori kelas';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText:'Harga'),
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
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    if (id == null){
                      _addMapel();
                    }else{
                      _updateMapel(id);
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

    Future<void> _addMapel() async {
      await dbHelper.insertMapel({
        'mapel':_mapelController.text,
        'kategorikelas':_kategorikelasController.text,
        'harga':_hargaController.text,
      });
      _refreshMapel();
    }

    Future<void> _updateMapel(int id) async {
      await dbHelper.updateMapel({
        'id':id,
        'mapel':_mapelController.text,
        'kategorikelas':_kategorikelasController.text,
        'harga':_hargaController.text,  
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
        appBar: AppBar(
          title: const Text('Lesson'),
        ),
        body: ListView.builder(
          itemCount: _mapel.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(_mapel[index]['mapel']),
              subtitle: Text(_mapel[index]['harga']),
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