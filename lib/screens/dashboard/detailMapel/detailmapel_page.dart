import 'package:flutter/material.dart';

class DetailmapelPage extends StatelessWidget {
  final String namamapel;
  final String namaguru;
  final String kelas;
  final String harga;
  final String? gambar;

  const DetailmapelPage({
    Key? key,
    required this.namamapel,
    required this.namaguru,
    required this.kelas,
    required this.harga,
    required this.gambar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(right: 10),
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
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: Column(
        children: [Text('$namamapel')],
      ),
    );
  }
}
