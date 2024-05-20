// ignore_for_file: non_constant_identifier_names, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _1Controller;
  late final AnimationController _2Controller;
  late final Animation<double> _fadein;
  late final Animation<double> _fadein1;
  late final Animation<double> _fadein2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _1Controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _2Controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _fadein = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _fadein1 = CurvedAnimation(
      parent: _1Controller,
      curve: Curves.easeIn,
    );
    _fadein2 = CurvedAnimation(
      parent: _2Controller,
      curve: Curves.easeIn,
    );

    // mulai animasi
    _controller.forward();
    //delay mulai fade in nya
    Future.delayed(const Duration(milliseconds: 500), () {
      _1Controller.forward();
    });
    Future.delayed(const Duration(milliseconds: 550), () {
      _2Controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _1Controller.dispose();
    _2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffDEE3F1), Color(0xffBCCFFF), Color(0xff8EB3FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadein,
                child: Image.asset(
                  "lib/assets/images/intro_2.png",
                  height: 220,
                  width: 232,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              FadeTransition(
                opacity: _fadein1,
                child: const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 70.0,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FadeTransition(
                opacity: _fadein2,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Education is the best                             investment you can make                                        for your self and your future.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
