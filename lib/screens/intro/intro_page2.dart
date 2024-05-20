import 'package:flutter/material.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
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