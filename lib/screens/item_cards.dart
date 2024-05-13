import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final DateTime jadwal;
  final String platformmeeting;
  //update function
  final Function onUpdate;
  //delete function
  final Function onDestroy;

  ItemCard(this.jadwal, this.platformmeeting,
      {required this.onDestroy, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text('Pengajuan'),
              ),
              Text('Jadwal : $jadwal'),
            ],
         ),
        ],
      ),
    );
  }
}
