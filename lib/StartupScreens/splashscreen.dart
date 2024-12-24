import 'dart:async';

import 'package:condition_report/StartupScreens/signIn.dart';
import 'package:condition_report/StartupScreens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignupScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF5C949B),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: SizedBox(
          width: 358,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 221,
                width: 358,
                child: SvgPicture.asset("assets/images/logo-svg.svg"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
