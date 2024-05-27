import 'package:flutter/material.dart';
import 'package:knowledge/screens/dashboard/Admin/tablebanner.dart';
import 'package:knowledge/screens/dashboard/Admin/tableguru.dart';
import 'package:knowledge/screens/dashboard/Admin/tablekategori.dart';

class AdminTable extends StatelessWidget {
  const AdminTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Admin Only',
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
              children: [
                Card(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Tableguru();
                      }));
                    },
                    child: const ListTile(
                      title: Text('Teacher List'),
                      leading: Icon(Icons.person),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Tablekategori();
                      }));
                    },
                    child: const ListTile(
                      title: Text('Category List'),
                      leading: Icon(Icons.book_rounded),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BannerPage();
                      }));
                    },
                    child: const ListTile(
                      title: Text('Banner List'),
                      leading: Icon(Icons.image),
                    ),
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
