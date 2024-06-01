// ignore_for_file: avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:knowledge/screens/dashboard/home_page.dart';
import 'package:knowledge/screens/dashboard/lesson_page.dart';
import 'package:knowledge/screens/dashboard/listtable.dart';
// import 'package:knowledge/screens/dashboard/notification_page.dart';
import 'package:knowledge/screens/dashboard/profile_page.dart';
import 'package:knowledge/screens/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'BottomNavbar';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //alert logout
  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user harus menutup dialog secara eksplisit
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFFFFFF),
          title: const Text('Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Tombol untuk menutup dialog dan kembali ke halaman sebelumnya
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = _previousIndex;
                });
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Tombol untuk logout dan pindah ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;
  int _previousIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LessonPage(),
    AdminTable(),
    ProfilePage(),
  ];

  void _onTimeTapped(int index) {
    setState(() {
      if (index == _widgetOptions.length - 1) {
        // Menyimpan indeks sebelumnya sebelum menampilkan dialog
        _previousIndex = _selectedIndex;
        // Menampilkan dialog ketika tombol Logout ditekan
        showLogoutDialog(context);
      } else {
        // Menavigasi ke halaman terkait jika tidak ada dialog logout yang ditampilkan
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 40),
              ),
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
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffFFFFFF),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: "",
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_rows),
            label: "",
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications),
          //   label: "",
          //   backgroundColor: Color.fromARGB(255, 255, 255, 255),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "",
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color.fromARGB(255, 158, 135, 228),
        onTap: _onTimeTapped,
      ),
    );
  }
}
