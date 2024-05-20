import 'package:flutter/material.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
       decoration: const BoxDecoration(
        gradient: LinearGradient(colors: 
         [Color(0xffDEE3F1), Color(0xffBCCFFF), Color(0xff8EB3FA)],
         begin: Alignment.topCenter,
         end: Alignment.bottomCenter),
       ),
      ),
    );
  }
}