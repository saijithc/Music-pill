import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/controller/nowplaying/nowplaying_controller.dart';
import 'package:music/functions/functions.dart';
import 'package:music/view/about.dart';

import 'splash.dart';

class PopUp extends GetView {
  PopUp({Key? key}) : super(key: key);

  final playercontroller = Get.put(NowPlayingController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Text('About'),
          onTap: () {
            Get.to(const About());
          },
        ),
        const Divider(),
        ListTile(
          leading: const Text('Reset App'),
          onTap: () {
            Get.defaultDialog(
                title: " Do you want to reset your app ? ",
                titlePadding: const EdgeInsets.all(10),
                middleText:
                    "All your playlist and favourite songs will be lost !",
                middleTextStyle:
                    const TextStyle(color: Color.fromARGB(255, 140, 6, 6)),
                onCancel: () {
                  Get.back();
                },
                onConfirm: () {
                  Dbfunctions.resetfav();
                  playercontroller.player.pause();
                  Dbfunctions.resetplaylist();
                  Get.to(Splash());
                });
          },
        ),
      ],
    );
  }
}
