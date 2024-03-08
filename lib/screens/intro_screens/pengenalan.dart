import 'package:flutter/material.dart';

class Pengenalan extends StatefulWidget {
  const Pengenalan({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PengenalanState createState() => _PengenalanState();
}

class _PengenalanState extends State<Pengenalan> with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _btnAnimationController;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<Offset> _btnAnimation;

  @override
  void initState() {
    super.initState();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _btnAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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

    _btnAnimation = Tween<Offset>(
      begin: const Offset(3, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _btnAnimationController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(milliseconds: 1000), () {
      _imageAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      _textAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      _btnAnimationController.forward();
    });
  }

  void _onNextButtonPressed() {
    setState(() {
       _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _btnAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

      Future.delayed(const Duration(milliseconds: 1000), () {
        _imageAnimationController.forward();
      });
      Future.delayed(const Duration(milliseconds: 1400), () {
        _textAnimationController.forward();
      });
      Future.delayed(const Duration(milliseconds: 1800), () {
        _btnAnimationController.forward();
      });

      _imageAnimation = Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(-2, 0),
      ).animate(CurvedAnimation(
        parent: _imageAnimationController,
        curve: Curves.easeInOut,
      ));

      _textAnimation = Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(-2, 0),
      ).animate(CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeInOut,
      ));

      _btnAnimation = Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(-3, 0),
      ).animate(CurvedAnimation(
        parent: _btnAnimationController,
        curve: Curves.easeInOut,
      ));
    });

    // _imageAnimationController.forward();
    // _textAnimationController.forward();
    // _btnAnimationController.forward();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _textAnimationController.dispose();
    _btnAnimationController.dispose();
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
            alignment: const Alignment(0.85, 0.35),
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
          Align(
            alignment: const Alignment(0, 0.71),
            child: GestureDetector(
              onTap: _onNextButtonPressed,
              child: SlideTransition(
                position: _btnAnimation,
                child: Container(
                  width: 300,
                  height: 39,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Center(
                    child: Text(
                      'NEXT',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
