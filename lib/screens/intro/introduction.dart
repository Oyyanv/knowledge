import 'package:flutter/material.dart';
import 'package:knowledge/screens/intro/intro_page2.dart';
import 'package:knowledge/screens/intro/intro_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intro_page.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //view introduction
          PageView(
            controller: _pageController,
            children: [
              IntroPage(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.60),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                  dotColor: Color(0xffEBEBEB),
                  activeDotColor: Color(0xffFFFFFF),
                  dotWidth: 10,
                  dotHeight: 5),
            ),
          ),
        ],
      ),
    );
  }
}
