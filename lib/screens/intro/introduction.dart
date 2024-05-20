// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:knowledge/screens/intro/intro_page2.dart';
import 'package:knowledge/screens/intro/intro_page3.dart';
import 'package:knowledge/screens/login/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intro_page.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  //kontroller pagenya
  final PageController _pageController = PageController();

  //boolean untuk mengubah continue saat di last page
  bool pageTerakhir = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //view introduction
          PageView(
            controller: _pageController,
            //jika halaman pagenya sudah halaman ke 2 maka halaman ke 3 akan terakhir dan mengubah text buttonnya
            onPageChanged: (halaman) {
              setState(() {
                pageTerakhir = (halaman == 2);
              });
            },
            children: const [
              IntroPage(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.90),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                      dotColor: Color(0xffEBEBEB),
                      activeDotColor: Color(0xffFFFFFF),
                      dotWidth: 10,
                      dotHeight: 5),
                ),
                const SizedBox(height: 56),
                //kalo halaman ke 2 selesai maka akan berubah ke get started
                pageTerakhir
                    ? Container(
                        width: 140,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xff98AAEA),
                              Color(0xff6579C1),
                              Color(0xff5A4D9A)
                            ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginPage();
                                }));
                              },
                              child: Text(
                                'Get Started',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    : Container(
                        width: 140,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xff98AAEA),
                              Color(0xff6579C1),
                              Color(0xff5A4D9A)
                            ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                            )
                          ],
                        )),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
