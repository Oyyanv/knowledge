import 'package:flutter/material.dart';
import 'intro/introduction.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _bounceController;
  late final AnimationController _secondController;
  late final AnimationController _thirdController;
  late final AnimationController _fourthController;
  late final AnimationController _gambarController;
  late final AnimationController _fadeOutController;
  late final AnimationController _backGroundController;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<Offset> _offsetGambar;
  late final Animation<Offset> _text1;
  late final Animation<Offset> _text2;
  late final Animation<Offset> _text3;
  late final Animation<Offset> _text4;
  late final Animation<double> _bounceLogo;
  late final Animation<double> _fadeOutAnimation;
  late final Animation<Decoration> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    _initializeAnimations();

    _startAnimations();

    _navigateHome();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _backGroundController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _secondController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _gambarController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _thirdController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fourthController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeOutController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -10.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );

    _offsetGambar = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.7, 0),
    ).animate(
      CurvedAnimation(
        parent: _gambarController,
        curve: Curves.easeInOut,
      ),
    );

    _text1 = Tween<Offset>(
      begin: const Offset(-11, 0),
      end: const Offset(-0.1, -0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _text2 = Tween<Offset>(
      begin: const Offset(-0.2, 2.1),
      end: const Offset(0.4, 1),
    ).animate(CurvedAnimation(
      parent: _secondController,
      curve: Curves.easeInOut,
    ));

    _text3 = Tween<Offset>(
      begin: const Offset(11, 1.8),
      end: const Offset(0.4, 2),
    ).animate(CurvedAnimation(
      parent: _thirdController,
      curve: Curves.easeInOut,
    ));

    _text4 = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.8, -1.1),
    ).animate(CurvedAnimation(
      parent: _fourthController,
      curve: Curves.easeInOut,
    ));

    _bounceLogo = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );

    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
    );

    _backgroundAnimation = TweenSequence<Decoration>([
      TweenSequenceItem(
        tween: DecorationTween(
          begin: const BoxDecoration(),
          end: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffDEE3F1), Color(0xffBCCFFF), Color(0xff8EB3FA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        weight: 1.0,
      ),
    ]).animate(_backGroundController);
  }

  void _startAnimations() {
    _controller.forward();
    _thirdController.forward();

    Future.delayed(const Duration(milliseconds: 1400), () {
      _secondController.forward();
      _fourthController.forward();
      _gambarController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      _backGroundController.forward();
    });
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Introduction(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backGroundController,
        builder: (context, child) {
          return Container(
            decoration: _backgroundAnimation.value,
            child: Center(
              child: AnimatedBuilder(
                animation: _fadeOutController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeOutAnimation.value,
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: Listenable.merge(
                              [_controller, _gambarController]),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: _offsetAnimation.value *
                                  (1 - _bounceLogo.value) *
                                  40,
                              child: child,
                            );
                          },
                          child: SlideTransition(
                            position: _offsetGambar,
                            child: Image.asset(
                              'lib/assets/images/logonnew.png',
                              height: 70,
                              width: 70,
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: Listenable.merge(
                              [_controller, _secondController]),
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
                                    color: Color(0xff404080),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: Listenable.merge(
                              [_thirdController, _fourthController]),
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
                                    color: Color(0xff404080),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _gambarController.dispose();
    _fadeOutController.dispose();
    _backGroundController.dispose();
    _bounceController.dispose();
    super.dispose();
  }
}
