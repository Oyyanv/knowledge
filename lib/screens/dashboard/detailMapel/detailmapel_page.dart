// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

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
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(right: 64),
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
        children: [
          Image.memory(
            base64Decode(gambar!),
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.grey[200],
            height: 350,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    Text(
                      '$namamapel',
                      style: const TextStyle(
                          color: Color(0xFF404080),
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Grade : $kelas'),
                    Text('Teacher : $namaguru'),
                    Text('Price : $harga')
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
