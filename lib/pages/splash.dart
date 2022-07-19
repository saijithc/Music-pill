import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/main.dart';
import '../functions/functions.dart';

class Splash extends GetView {
  Splash({Key? key}) : super(key: key);
  @override
  final controller = Get.put(Dbfunctions());
  @override
  Widget build(BuildContext context) {
    controller.displaySongs();
    return AnimatedSplashScreen(
      splashIconSize: MediaQuery.of(context).size.height * 0.5,
      splash: 'assets/splash.jpg',
      nextScreen: Mainhome(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.black,
    );
  }
}
