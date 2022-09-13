import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:music/controller/nowplaying/nowplaying_controller.dart';
import 'package:music/view/favorite_check.dart';
import 'package:music/functions/functions.dart';
import 'package:music/view/playlist_add_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class NowPlaying extends GetView {
  NowPlaying({Key? key}) : super(key: key);
  static List<SongModel>? finallist = [];
  final nowController = Get.put(NowPlayingController());
  @override
  final controller = Get.put(Dbfunctions());
  //<<...................duration state stream......................>>
  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          nowController.player.positionStream,
          nowController.player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: (IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.keyboard_arrow_down),
        )),
        title: const Text(
          'Now Playing',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GetBuilder<NowPlayingController>(
          init: NowPlayingController(),
          builder: (ctx) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: GestureDetector(
                      onHorizontalDragEnd: (dragDownDetails) {
                        if (dragDownDetails.primaryVelocity! < 0) {
                          if (nowController.player.hasNext) {
                            nowController.player
                                .seekToNext()
                                .whenComplete(() => nowController.update());
                          }
                        } else if (dragDownDetails.primaryVelocity! > 0) {
                          if (nowController.player.hasPrevious) {
                            nowController.player
                                .seekToPrevious()
                                .whenComplete(() => nowController.update());
                          }
                        }
                      },
                      child: GetBuilder<NowPlayingController>(
                          builder: (controller) {
                        return QueryArtworkWidget(
                          nullArtworkWidget: Image.asset(
                            "assets/logo.jpg",
                            fit: BoxFit.cover,
                          ),
                          id: nowController
                              .mainList[nowController.player.currentIndex!].id,
                          type: ArtworkType.AUDIO,
                          artworkFit: BoxFit.fitWidth,
                          artworkHeight: 60,
                          artworkQuality: FilterQuality.high,
                          artworkBorder: BorderRadius.circular(15),
                          size: 500,
                        );
                      }),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: SizedBox(
                            height: 50,
                            width: w / 1.5,
                            child: Marquee(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              text: nowController
                                  .mainList[nowController.player.currentIndex!]
                                  .title,
                              pauseAfterRound: const Duration(seconds: 10),
                              velocity: 30,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Text(
                          nowController
                                  .mainList[nowController.player.currentIndex!]
                                  .artist ??
                              'unknown',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 159, 158, 158),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      //<<...........................Library icon and Favourite....................................>>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PlaylistButton(),
                          GetBuilder<Dbfunctions>(builder: (controller) {
                            return FavCheck(
                              id: nowController
                                  .mainList[nowController.player.currentIndex!]
                                  .id,
                            );
                          }),
                          Flexible(
                              child: InkWell(
                            onTap: () {
                              nowController.player.loopMode == LoopMode.one
                                  ? nowController.player
                                      .setLoopMode(LoopMode.all)
                                  : nowController.player
                                      .setLoopMode(LoopMode.one);
                            },
                            child: StreamBuilder<LoopMode>(
                              stream: nowController.player.loopModeStream,
                              builder: (context, snapshot) {
                                final loopmode = snapshot.data;
                                if (LoopMode.one == loopmode) {
                                  return const Icon(
                                    Icons.repeat_one,
                                    color: Colors.green,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.repeat,
                                    color: Colors.white54,
                                  );
                                }
                              },
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      //<<......................Slider creation...........................>>
                      Column(
                        children: [
                          //<<.............slider bar container.....................>>
                          Container(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            margin: const EdgeInsets.only(bottom: 4.0),
                            //<<.............    slider bar duration state   ...............................>>
                            child: StreamBuilder<DurationState>(
                                stream: durationStateStream,
                                builder: (context, snapshot) {
                                  final durationState = snapshot.data;
                                  final progress =
                                      durationState?.position ?? Duration.zero;
                                  final total =
                                      durationState?.total ?? Duration.zero;

                                  return ProgressBar(
                                    progress: progress,
                                    total: total,
                                    barHeight: 3,
                                    progressBarColor: const Color.fromARGB(
                                        255, 151, 234, 153),
                                    baseBarColor: const Color.fromARGB(
                                        255, 207, 208, 208),
                                    thumbColor:
                                        const Color.fromARGB(255, 2, 241, 193),
                                    timeLabelPadding: 8,
                                    timeLabelTextStyle:
                                        const TextStyle(color: Colors.white),
                                    onSeek: (duration) {
                                      nowController.player.seek(duration);
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                      //<<..............................buttons creation [PREVIOUS / PLAY / PAUSE / NEXT ]...................>>
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //<<<..................................previous button .....................>>>
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  if (nowController.player.hasPrevious) {
                                    nowController.player.stop();
                                    nowController.player
                                        .seekToPrevious()
                                        .whenComplete(() {
                                      nowController.update();
                                      nowController.player.play();
                                    });
                                  } else {
                                    nowController.player.play();
                                    // setState(() {});
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: getDecoration(BoxShape.circle,
                                      const Offset(2, 2), 2.0, 0.0),
                                  child: const Icon(
                                    Icons.skip_previous,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                            //<<.......................play pause......................................>>
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  if (nowController.player.playing) {
                                    nowController.player.pause();
                                  } else {
                                    if (nowController.player.currentIndex !=
                                        null) {
                                      nowController.player.play();
                                    }
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: getDecoration(BoxShape.circle,
                                        const Offset(2, 2), 2.0, 0.0),
                                    child: StreamBuilder<bool>(
                                      stream:
                                          nowController.player.playingStream,
                                      builder: (context, snapshot) {
                                        bool? playingState = snapshot.data;
                                        if (playingState != null &&
                                            playingState) {
                                          return const Icon(
                                            Icons.pause,
                                            size: 40,
                                            color: Colors.white,
                                          );
                                        }
                                        return const Icon(
                                          Icons.play_arrow,
                                          size: 40,
                                          color: Colors.white,
                                        );
                                      },
                                    )),
                              ),
                            ),
                            //<<................................next song .........................>>
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  if (nowController.player.hasNext) {
                                    nowController.player.stop();
                                    nowController.player.play();
                                    nowController.player
                                        .seekToNext()
                                        .whenComplete(
                                            () => nowController.update());
                                  } else {
                                    nowController.player.play();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: getDecoration(BoxShape.circle,
                                      const Offset(2, 2), 2.0, 0.0),
                                  child: const Icon(
                                    Icons.skip_next,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: const Color.fromARGB(255, 108, 209, 128),
      shape: shape,
    );
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
