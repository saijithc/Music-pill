import 'package:flutter/material.dart';
import 'package:music/main.dart';

import 'functions/functions.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    gotohome(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Dbfunctions.displaySongs();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/splash.jpg'), fit: BoxFit.cover)),
      ),
    );
  }
}

Future<void> gotohome(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (ctx) =>  Mainhome()));
}
