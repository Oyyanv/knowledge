import 'package:flutter/material.dart';
import 'package:knowledge/screens/home.dart';

class Tablebanner extends StatefulWidget {
  const Tablebanner({super.key});

  @override
  State<Tablebanner> createState() => _TablebannerState();
}

class _TablebannerState extends State<Tablebanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
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
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: const [
                Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Banner List'),
                    leading: Icon(Icons.person),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}