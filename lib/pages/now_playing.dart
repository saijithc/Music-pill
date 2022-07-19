import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/controller/nowplaying/nowplaying_controller.dart';
import 'package:music/pages/favorite_check.dart';
import 'package:music/functions/functions.dart';
import 'package:music/pages/check_playlist.dart';
import 'package:music/pages/library.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class NowPlaying extends GetView {
  NowPlaying(void addAll, {Key? key}) : super(key: key);
  static List<SongModel> songlists = [];

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
                            // setState(() {
                            // });
                          }
                        } else if (dragDownDetails.primaryVelocity! > 0) {
                          if (nowController.player.hasPrevious) {
                            nowController.player
                                .seekToPrevious()
                                .whenComplete(() => nowController.update());
                            // setState(() { });
                          }
                        }
                      },
                      child: GetBuilder<NowPlayingController>(
                          builder: (controller) {
                        return QueryArtworkWidget(
                          id: songlists[nowController.player.currentIndex!].id,
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
                          child: Text(
                            songlists[nowController.player.currentIndex!].title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Text(
                          songlists[nowController.player.currentIndex!]
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
                          IconButton(
                              onPressed: () {
                                controller.getAllplaylist();
                                //<<<<<<<<....................................BOTTOMSHEET CREATION FOR ADDING SONGS TO THE AVAILABLE PLAYLIST......................>>>>>>>>>>>>
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Add to playlist',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25, right: 25),
                                            child: InkWell(
                                              onTap: () {
                                                // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> Library()));
                                                Get.to(Library());
                                              },
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.50,
                                                  width: double.infinity,
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 252, 254, 254),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(40),
                                                              topRight: Radius
                                                                  .circular(
                                                                      40))),
                                                  child:
                                                      GetBuilder<Dbfunctions>(
                                                    init: Dbfunctions(),
                                                    builder: (controller)
                                                        // ValueListenableBuilder(valueListenable: Dbfunctions.playlist,
                                                        //   builder: (BuildContext context, List<dynamic> value, Widget? child)
                                                        {
                                                      if (controller
                                                          .playlist.isEmpty) {
                                                        return Container(
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/waiting.gif'),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  'Oops! No Playlist Found',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.05),
                                                                ),
                                                              ),
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  'Tap to create new playlist',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      return GetBuilder<
                                                              Dbfunctions>(
                                                          builder:
                                                              (controller) {
                                                        return ListView.builder(
                                                            itemCount:
                                                                controller
                                                                    .playlist
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            20),
                                                                child: ListTile(
                                                                  leading:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.19,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(
                                                                              'assets/logo.jpg'),
                                                                          fit: BoxFit
                                                                              .cover),
                                                                    ),
                                                                  ),
                                                                  title: Text(
                                                                    controller
                                                                        .playlist[
                                                                            index]
                                                                        .foldername!
                                                                        .toUpperCase(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                  subtitle:
                                                                      const Text(
                                                                    'Playlist',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  trailing: CheckPlaylist(
                                                                      index: nowController
                                                                          .player
                                                                          .currentIndex!,
                                                                      folderindex:
                                                                          index,
                                                                      id: songlists[nowController
                                                                              .player
                                                                              .currentIndex!]
                                                                          .id),
                                                                ),
                                                              );
                                                            });
                                                      });
                                                    },
                                                  )),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                                //<<<<<<<<<<<<<...............................END OF BOTTOMSHEET FOR ADDING SONGS TO THE AVAILABLE PLAYLIST FOLDERS...........................>>>>>>>>>>>>
                              },
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white54,
                                size: 30,
                              )),
                          GetBuilder<Dbfunctions>(builder: (controller) {
                            return FavCheck(
                              id: songlists[nowController.player.currentIndex!]
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
