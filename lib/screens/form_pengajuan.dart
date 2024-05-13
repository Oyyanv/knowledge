import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'detailpage.dart';

void main() {
  runApp(MaterialApp(
    title: "test login form",
    debugShowCheckedModeBanner: false,
    home: const BelajarForm(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
  ));
}

class BelajarForm extends StatefulWidget {
  const BelajarForm({super.key});

  @override
  State<BelajarForm> createState() => _BelajarFormState();
}

class _BelajarFormState extends State<BelajarForm> {
  //datepickernya
  Future<void> _selectDate() async {
    DateTime? pick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025));

    if (pick != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pick);
        jadwal.text = formattedDate;
      });
    }
  }

  // final _formKey = GlobalKey<FormState>();
  final jadwal = TextEditingController();
  final platformmeeting = TextEditingController();

  //variabel value dropwdown
  String? _dropdownValue;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/images/book.png',
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
      ),
      //buat form
      body: Form(
        //unique key untuk identifikasi form
        // key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            //semua widget ke kiri
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text('Pengajuan'),
              ),
              const SizedBox(height: 20),
              //memberi jarak
              TextFormField(
                //controller: name untuk memberitahu bahwa inputan field ini adalah punya variabel name
                controller: jadwal,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Tentukan Jadwal (yyyy-mm-dd)",
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
                //validasi if form kosong
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Jadwal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Platform Meeting',
                      errorText: state.errorText,
                    ),
                    isEmpty: _dropdownValue == null,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _dropdownValue,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                            platformmeeting.text = newValue ?? '';
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            child: Text('Google Meet'),
                            value: 'Google Meet',
                          ),
                          DropdownMenuItem(
                            child: Text('Zoom Meet'),
                            value: 'Zoom Meet',
                          ),
                        ],
                      ),
                    ),
                  );
                },
                validator: (value) {
                  if (_dropdownValue == null || _dropdownValue!.isEmpty) {
                    return 'Pilih platform meeting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('Add Button'),
                  onPressed: () {
                    
                  },style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amberAccent)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
