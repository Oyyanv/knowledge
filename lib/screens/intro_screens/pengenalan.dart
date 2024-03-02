import 'package:flutter/material.dart' show Align, Alignment, Animation, AnimationController, BuildContext, Color, Colors, Container, CurvedAnimation, Curves, FontWeight, Image, Key, Offset, SizedBox, SlideTransition, Stack, State, StatefulWidget, Text, TextAlign, TextStyle, TickerProviderStateMixin, Tween, Widget;

class Pengenalan extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Pengenalan({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _PengenalanState createState() => _PengenalanState();
}

class _PengenalanState extends State<Pengenalan>
    with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AnimationController _textAnimationController;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Image animation duration
    );
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Text animation duration
    );

    _imageAnimation = Tween<Offset>(
      begin: const Offset(2, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    ));

    _textAnimation = Tween<Offset>(
      begin: const Offset(2, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      _imageAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _textAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff7887BB),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.80),
            child: SlideTransition(
              position: _imageAnimation,
              child: Image.asset(
                'lib/assets/images/iconremovebg.png',
                width: 320,
                height: 500,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.49),
            child: SlideTransition(
              position: _textAnimation,
              child: const SizedBox(
                width: 327,
                child: Text(
                  'This application is for educational services to elementary, junior high and senior high school students.',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
