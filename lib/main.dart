import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/view/splash.dart';

Future<void> main() async {
  final controller = Get.put(Dbfunctions());
  //<<.....................app rotation of............>>
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //<<<<<<<<.....................backgroundplay.................>>>>>>>>>>>>>>
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(PlaylistsModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistsModelAdapter());
  }
  controller.getAllsongs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}
