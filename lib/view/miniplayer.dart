import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:music/controller/nowplaying/nowplaying_controller.dart';
import 'package:music/view/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends GetView {
  MiniPlayer({Key? key}) : super(key: key);
  final playercontroller = Get.put(NowPlayingController());
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Positioned(
        //<<<<<<<<<<<<<<<<<......................***.MINI PLAYER SCREEN CREATION.***..................>>>>>>>>>>>>>>>>>>>
        child: playercontroller.player.currentIndex != null ||
                playercontroller.player.playing
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: InkWell(
                  child: Container(
                    height: h * .075,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onHorizontalDragEnd: (dragDownDetails) {
                        if (dragDownDetails.primaryVelocity! < 0) {
                          if (playercontroller.player.hasNext) {
                            playercontroller.player
                                .seekToNext()
                                .whenComplete(() => playercontroller.update());
                            // setState(() {});
                          }
                        } else if (dragDownDetails.primaryVelocity! > 0) {
                          if (playercontroller.player.hasPrevious) {
                            playercontroller.player
                                .seekToPrevious()
                                .whenComplete(() => playercontroller.update());
                            // setState(() {});
                          }
                        }
                      },
                      child:
                          GetBuilder<NowPlayingController>(builder: (context) {
                        return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Marquee(
                              text: playercontroller
                                  .mainList[
                                      playercontroller.player.currentIndex!]
                                  .title,
                              pauseAfterRound: const Duration(seconds: 10),
                              velocity: 30,
                            ),
                          ),
                          leading: CircleAvatar(
                              child: QueryArtworkWidget(
                            nullArtworkWidget: Image.asset(
                              "assets/logo.jpg",
                              fit: BoxFit.cover,
                            ),
                            id: playercontroller
                                .mainList[playercontroller.player.currentIndex!]
                                .id,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.cover,
                          )),
                          trailing: InkWell(
                            onTap: () async {
                              if (playercontroller.player.playing) {
                                playercontroller.player.pause();
                              } else {
                                if (playercontroller.player.currentIndex !=
                                    null) {
                                  playercontroller.player.play();
                                }
                              }
                            },
                            //<<<<<<<<..........................PLAY PAUSE BUTTON CREATION.. ........................>>>>>
                            child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: getDecoration(BoxShape.circle,
                                    const Offset(2, 2), 2.0, 0.0),
                                child: StreamBuilder<bool>(
                                  stream: playercontroller.player.playingStream,
                                  builder: (context, snapshot) {
                                    bool? playingState = snapshot.data;
                                    if (playingState != null && playingState) {
                                      return const Icon(
                                        Icons.pause,
                                        size: 20,
                                        color: Colors.white,
                                      );
                                    }
                                    return const Icon(Icons.play_arrow,
                                        size: 20, color: Colors.white);
                                  },
                                )),
                          ),
                        );
                      }),
                    ),
                  ),
                  onTap: () {
                    Get.to(NowPlaying());
                  },
                ),
              )
            : const Text('')

        //<<<<<<<<<<<<<<<<<<<<<<................ENDING OF MINIPLAYER SCREEN CREATION..........................................>>>>>>>>>>>>>>
        );
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: const Color.fromARGB(255, 93, 212, 116),
      shape: shape,
    );
  }
}
