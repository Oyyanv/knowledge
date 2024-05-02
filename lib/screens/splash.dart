import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  //controller animasinya yg akan di deklarasi
  late AnimationController _controller;
  late AnimationController _secondcontroller;
  late AnimationController _thirdcontroller;
  late AnimationController _fourthcontroller;
  late AnimationController _gambarcontroller;
  //mengontrol pergerakan widget
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _offsetgambar;
  late Animation<Offset> _text1;
  late Animation<Offset> _text2;
  late Animation<Offset> _text3;
  late Animation<Offset> _text4;
  //bisa ngontrol animasinya
  late Animation<double> _bouncelogo;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _secondcontroller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _gambarcontroller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    //sinkronisasi animasinya dan durasi
    _thirdcontroller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    //sinkronisasi animasinya dan durasi
    _fourthcontroller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    //logo dari atas ke tengah
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -10.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    //gambar ke samping
    _offsetgambar = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.7, 0),
    ).animate(
      CurvedAnimation(
        parent: _gambarcontroller,
        curve: Curves.easeInOut,
      ),
    );
    //samping kiri ke tengah
    _text1 = Tween<Offset>(
      begin: const Offset(-11, 0),
      end: const Offset(-0.1, -0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    //bawah logo ke samping kanan
    _text2 = Tween<Offset>(
      begin: const Offset(-0.2, 2.1),
      end: const Offset(0.4, 1),
    ).animate(CurvedAnimation(
      parent: _secondcontroller,
      curve: Curves.easeInOut,
    ));
    //kanan ke tengah
    _text3 = Tween<Offset>(
      begin: const Offset(11, 1.8),
      end: const Offset(0.4, 2),
    ).animate(CurvedAnimation(
      parent: _thirdcontroller,
      curve: Curves.easeInOut,
    ));

    //tengah ke samping 'know'
    _text4 = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.8, -1.1),
    ).animate(CurvedAnimation(
      parent: _fourthcontroller,
      curve: Curves.easeInOut,
    ));
    //buat mantulin
    _bouncelogo = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    //animasi yg mulai duluan
    _controller.forward();
    _thirdcontroller.forward();
    

    // Delay untuk animasi second controller
    Future.delayed(const Duration(seconds: 2), () {
      _secondcontroller.forward();
    });
    //third controllernya di delay
    Future.delayed(const Duration(seconds: 2), () {
      _fourthcontroller.forward();
    });
    //third controllernya di delay
    Future.delayed(const Duration(seconds: 2), () {
      _gambarcontroller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          // alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_controller, _gambarcontroller]),
              builder: (context, child) {
                return Transform.translate(
                  offset: _offsetAnimation.value *
                      (1 - _bouncelogo.value) *
                      40, // Adjust nilai untuk ketinggian pantulan
                  child: child,
                );
              },
              child: SlideTransition(
                position: _offsetgambar,
                child: Image.asset(
                  'lib/assets/images/logonnew.png',
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_controller, _secondcontroller]),
              builder: (context, child) {
                return SlideTransition(
                  position: _text1,
                  child: SlideTransition(
                    position: _text2,
                    child: const Text(
                      'Know    ',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff404080)),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation:
                  Listenable.merge([_thirdcontroller, _fourthcontroller]),
              builder: (context, child) {
                return SlideTransition(
                  position: _text3,
                  child: SlideTransition(
                    position: _text4,
                    child: const Text(
                      ' ledge',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff404080)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

//memanggil controller animasinya
  @override
  void dispose() {
    _controller.dispose();
    _secondcontroller.dispose();
    _thirdcontroller.dispose();
    _fourthcontroller.dispose();
    _gambarcontroller.dispose();
    super.dispose();
  }
}
