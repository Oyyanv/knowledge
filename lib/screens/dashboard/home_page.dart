import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:knowledge/db_helper.dart';
// import 'package:knowledge/screens/dashboard/lesson_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DBHelper();
  List<Map<String, dynamic>> _banner = [];
  List<Map<String, dynamic>> _kategori = [];
  List<Map<String, dynamic>> _guru = [];

  @override
  void initState() {
    super.initState();
    _refreshBanner();
    _refreshKategori();
    _refreshGuru();
  }

  void _refreshBanner() async {
    final data = await dbHelper.queryAllBanner();
    setState(() {
      _banner = data;
    });
  }

  void _refreshKategori() async {
    final data = await dbHelper.queryAllKategoriMapel();
    setState(() {
      _kategori = data;
    });
  }

  void _refreshGuru() async {
    final data = await dbHelper.queryAllGuru();
    setState(() {
      _guru = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_banner.isNotEmpty)
            ImageSlideshow(
              width: double.infinity,
              height: 180,
              isLoop: true,
              autoPlayInterval: 2500,
              indicatorBackgroundColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              children: _banner.map((banner) {
                Uint8List? imageBytes = banner['gambar_banner'];
                if (imageBytes != null) {
                  return Container(
                    key: ValueKey(banner['id']),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            ),
          const SizedBox(
            height: 10,
          ),
          // Kategori
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Subject List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff4B4949),
                  ),
                ),
              ),
              if (_kategori.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    itemCount: _kategori.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // onTap: () {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => LessonPage()));
                        // },
                        child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.memory(
                            base64Decode(_kategori[index]['gambar']),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // list guru
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Recommended Teacher',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff4B4949),
                  ),
                ),
              ),
            ],
          ),
          // Guru
          if (_guru.isNotEmpty)
            Expanded(
              child: ListView(
                children: _guru.map(
                  (guru) {
                    return Card(
                      color: const Color(0xffF7F7F7),
                      elevation: 8,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: guru['gambar_guru'] != null
                            ? Image.memory(
                                base64Decode(guru['gambar_guru']),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person, size: 50),
                        title: Text(guru['nama']),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gender : ${guru['gender']}'),
                                Text('Skill : ${guru['kemampuanmapel']}'),
                                Text('Email : ${guru['email']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
