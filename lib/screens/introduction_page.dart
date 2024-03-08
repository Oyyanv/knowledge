import 'package:flutter/material.dart';
import 'package:knowledge/screens/intro_screens/mulaiapp.dart';
import 'package:knowledge/screens/intro_screens/pengenalan.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Introductionpage extends StatefulWidget {
  const Introductionpage({super.key});

  @override
  State<Introductionpage> createState() => _IntroductionpageState();
}

class _IntroductionpageState extends State<Introductionpage> {
  //tracking page
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //page view
          PageView(
            controller: _controller,
            children: const [
              Pengenalan(),
              Mulaiapps(),
            ],
          ),
          // //Text pengenalan
          // Align(
          //   alignment: Alignment.center,
          //   child: Container(
          //     width: 327,
          //     alignment: const Alignment(0, 0.49),
          //     child: const Text(
          //       'This application is for educational services to elementary, junior high and senior high school students.',
          //       style: TextStyle(
          //           fontWeight: FontWeight.w200,
          //           color: Colors.white,
          //           fontSize: 18),
          //       textAlign: TextAlign.left,
          //     ),
          //   ),
          // ),
          //indicator
          Container(
            alignment: const Alignment(0, 0.90),
            child: SmoothPageIndicator(controller: _controller, count: 2),
          ),
        ],
      ),
    );
  }
}
