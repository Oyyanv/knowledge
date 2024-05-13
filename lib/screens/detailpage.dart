// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class DetailPage extends StatelessWidget {
//   //manggil data form tadi
//   // ignore: prefer_const_constructors_in_immutables
//   DetailPage(
//       {super.key,
     
    
//       required this.jadwal,
//     });


  
//   final String jadwal; 
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const Text('DATA DIRI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//           //menampilkan data form tadi
//           const Divider(
//             color: Colors.black,
//           ),
//           Text('Jadwal :' '$jadwal'),
//           const Divider(
//             color: Colors.black,
//           ),
//           const SizedBox(height: 15),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Kembali'))
//         ],
//       ),
//     );
//   }
// }
