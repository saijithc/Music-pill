import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:music/controller/bottom/bottom_controllers.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/pages/home.dart';
import 'package:music/pages/library.dart';
import 'package:music/pages/now_playing.dart';
import 'package:music/pages/search.dart';
import 'package:music/pages/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'controller/main/main_home_controller.dart';
import 'controller/nowplaying/nowplaying_controller.dart';

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

class Mainhome extends StatelessWidget {
  Mainhome({Key? key}) : super(key: key);
  final List<SongModel>? finallist = [];
  final controllerForBottom = Get.put(BottomController());
  final playercontroller = Get.put(NowPlayingController());
  final maincontroller = Get.put(MainHomeController());
  // int selectedIndex =0;
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageView(
          children: <Widget>[
            Home(),
            Search(),
            Library(),
          ],
          controller: controller,
          onPageChanged: (page) {
            controllerForBottom.changeIndex(page);
          },
        ),
        bottomNavigationBar: Stack(children: [
          SizedBox(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Obx(() => BottomNavigationBar(
                    unselectedItemColor:
                        const Color.fromARGB(153, 156, 151, 151),
                    currentIndex: controllerForBottom.selectedIndex.value,
                    onTap: _onItemTapped,
                    backgroundColor: Colors.black,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          activeIcon: CircleAvatar(
                            radius:
                                MediaQuery.of(context).size.aspectRatio * 40,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 1,
                              width: MediaQuery.of(context).size.width * 1,
                              child: const Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage('assets/bottom.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                          icon: const Icon(Icons.home),
                          label: ''),
                      BottomNavigationBarItem(
                          activeIcon: CircleAvatar(
                            radius:
                                MediaQuery.of(context).size.aspectRatio * 60,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 1,
                              width: MediaQuery.of(context).size.width * 1,
                              child: const Icon(
                                Icons.search,
                                size: 50,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage('assets/bottom.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                          icon: const Icon(Icons.search),
                          label: ''),
                      BottomNavigationBarItem(
                          activeIcon: CircleAvatar(
                            radius:
                                MediaQuery.of(context).size.aspectRatio * 40,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 1,
                              width: MediaQuery.of(context).size.width * 1,
                              child: const Icon(
                                Icons.music_note_outlined,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage('assets/bottom.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(28)),
                            ),
                          ),
                          icon: const Icon(
                            Icons.music_note_outlined,
                          ),
                          label: ''),
                    ],
                  )),
            ),
          ),
          GetBuilder<NowPlayingController>(
              init: NowPlayingController(),
              builder: (context) {
                return Positioned(

                    //<<<<<<<<<<<<<<<<<......................***.MINI PLAYER SCREEN CREATION.***..................>>>>>>>>>>>>>>>>>>>

                    child: playercontroller.player.currentIndex != null ||
                            playercontroller.player.playing
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 20),
                            child: InkWell(
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: GestureDetector(
                                  onHorizontalDragEnd: (dragDownDetails) {
                                    if (dragDownDetails.primaryVelocity! < 0) {
                                      if (playercontroller.player.hasNext) {
                                        playercontroller.player
                                            .seekToNext()
                                            .whenComplete(() =>
                                                playercontroller.update());
                                        // setState(() {});
                                      }
                                    } else if (dragDownDetails
                                            .primaryVelocity! >
                                        0) {
                                      if (playercontroller.player.hasPrevious) {
                                        playercontroller.player
                                            .seekToPrevious()
                                            .whenComplete(() =>
                                                playercontroller.update());
                                        // setState(() {});
                                      }
                                    }
                                  },
                                  child: GetBuilder<NowPlayingController>(
                                      builder: (context) {
                                    return ListTile(
                                      title: SizedBox(
                                          child: Marquee(
                                        text: NowPlaying
                                            .songlists[playercontroller
                                                .player.currentIndex!]
                                            .title,
                                        pauseAfterRound:
                                            const Duration(seconds: 10),
                                        velocity: 30,
                                      )),
                                      leading: CircleAvatar(
                                          child: QueryArtworkWidget(
                                        id: NowPlaying
                                            .songlists[playercontroller
                                                .player.currentIndex!]
                                            .id,
                                        type: ArtworkType.AUDIO,
                                        artworkFit: BoxFit.cover,
                                      )),
                                      trailing: InkWell(
                                        onTap: () async {
                                          if (playercontroller.player.playing) {
                                            playercontroller.player.pause();
                                          } else {
                                            if (playercontroller
                                                    .player.currentIndex !=
                                                null) {
                                              playercontroller.player.play();
                                            }
                                          }
                                        },
                                        //<<<<<<<<..........................PLAY PAUSE BUTTON CREATION.. ........................>>>>>
                                        child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: getDecoration(
                                                BoxShape.circle,
                                                const Offset(2, 2),
                                                2.0,
                                                0.0),
                                            child: StreamBuilder<bool>(
                                              stream: playercontroller
                                                  .player.playingStream,
                                              builder: (context, snapshot) {
                                                bool? playingState =
                                                    snapshot.data;
                                                if (playingState != null &&
                                                    playingState) {
                                                  return const Icon(
                                                    Icons.pause,
                                                    size: 20,
                                                    color: Colors.white,
                                                  );
                                                }
                                                return const Icon(
                                                    Icons.play_arrow,
                                                    size: 20,
                                                    color: Colors.white);
                                              },
                                            )),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              onTap: () {
                                for (var i = 0;
                                    i < playercontroller.playingdetails!.length;
                                    i++) {
                                  finallist!
                                      .add(playercontroller.playingdetails![i]);
                                }
                                Get.to(NowPlaying(playercontroller
                                    .playingdetails!
                                    .addAll(finallist!)));
                              },
                            ),
                          )
                        : const Text('')
                    //   }
                    // )
                    //<<<<<<<<<<<<<<<<<<<<<<................ENDING OF MINIPLAYER SCREEN CREATION..........................................>>>>>>>>>>>>>>
                    );
              })
        ]));
  }

  _onItemTapped(int index) {
    controllerForBottom.changeIndex(index);
    controller.jumpToPage(index);
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: const Color.fromARGB(255, 93, 212, 116),
      shape: shape,
    );
  }
}
