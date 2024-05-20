import 'package:flutter/material.dart';

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
        child: const SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
            ],),
        ),
      ),
    );
  }
}
