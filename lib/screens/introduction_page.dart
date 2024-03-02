import 'package:flutter/material.dart';
import 'package:knowledge/screens/intro_screens/mulaiapp.dart';
import 'package:knowledge/screens/intro_screens/pengenalan.dart';

class Introductionpage extends StatefulWidget {
  const Introductionpage({super.key});

  @override
  State<Introductionpage> createState() => _IntroductionpageState();
}

class _IntroductionpageState extends State<Introductionpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //page view
          PageView(
            children: const [
              Pengenalan(),
              Mulaiapps(),
            ],
          ),
        ],
      ),
    );
  }
}
