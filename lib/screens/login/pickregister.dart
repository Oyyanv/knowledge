import 'package:flutter/material.dart';
import 'package:knowledge/screens/login/register.dart';
import 'package:knowledge/screens/login/registerguru.dart';
import 'package:page_transition/page_transition.dart';

class PilihRegister extends StatefulWidget {
  const PilihRegister({super.key});

  @override
  State<PilihRegister> createState() => _PilihRegisterState();
}

class _PilihRegisterState extends State<PilihRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffFFFFFF),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff7D99E7),
                  Color(0xffBCCFFF),
                  Color(0xff8EB3FA)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Row(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 125,
                  ),
                  Image.asset(
                    'lib/assets/images/logonnew.png',
                    height: 60,
                    width: 60,
                  ),
                ],
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 135,
                  ),
                  Text(
                    ' Knowledge',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff404080),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: Registerguru(), type: PageTransitionType.fade),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffFFFFFF),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: Registerguru(),
                              type: PageTransitionType.fade),
                        );
                      },
                      child: Text('Sign Up Teacher'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: SignupPage(), type: PageTransitionType.fade),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffFFFFFF),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: SignupPage(),
                              type: PageTransitionType.fade),
                        );
                      },
                      child: Text('Sign Up User'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
