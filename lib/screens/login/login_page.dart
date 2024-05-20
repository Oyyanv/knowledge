import 'package:flutter/material.dart';
import 'package:knowledge/screens/intro/introduction.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff7D99E7),
          Color(0xffBCCFFF),
          Color(0xff8EB3FA)
        ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
        child: SizedBox.expand(
          child: Row(
            children: [
              //button kembali
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const Introduction();
                      }));
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
              //button kembali
              //knowledge icon
              Row(
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
                        '  Knowledge',
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
              //knowledge icon
              //card login
            ],
          ),
        ),
      ),
    );
  }
}
