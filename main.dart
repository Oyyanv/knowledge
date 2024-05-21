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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  final _mapelController = TextEditingController();
  final _kategorikelasController = TextEditingController();
  final _hargaController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }
  
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
      ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Mapel deleted')));
      _refreshMapel();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter CRUD with SQLite'),
        ),
        body: ListView.builder(
          itemCount: _mapel.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(_mapel[index]['mapel']),
              subtitle: Text(_mapel[index]['kategorikelas']),
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
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
}