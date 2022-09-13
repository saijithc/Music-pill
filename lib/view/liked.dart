import 'package:flutter/material.dart';
import 'package:music/view/concatinating.dart';
import 'package:music/view/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/nowplaying/nowplaying_controller.dart';
import '../functions/functions.dart';
import 'package:get/get.dart';

class LikedSongs extends GetView {
  LikedSongs({Key? key}) : super(key: key);
  @override
  final controller = Get.put(Dbfunctions());
  final playercontroller = Get.put(NowPlayingController());
  @override
  Widget build(BuildContext context) {
    controller.getAllsongs();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: null,
          backgroundColor: Colors.black,
          title: const Text(
            'Liked Songs',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 0, 0, 0),
          child: GetBuilder<Dbfunctions>(
            init: Dbfunctions(),
            builder: (controller) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.favouritesongs.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            playercontroller.player.setAudioSource(
                                Concatinatig.createPlaylist(
                                    controller.favouritesongs),
                                initialIndex: index);
                            playercontroller.mainList.clear();
                            playercontroller.addSong(controller.favouritesongs);
                            // NowPlaying.songlists.clear();
                            playercontroller.player.play();
                            Get.to(NowPlaying());
                          },
                          leading: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: MediaQuery.of(context).size.height * 0.19,
                            child: QueryArtworkWidget(
                                nullArtworkWidget: Image.asset(
                                  "assets/logo.jpg",
                                  fit: BoxFit.cover,
                                ),
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(2),
                                id: controller.favouritesongs[index].id,
                                type: ArtworkType.AUDIO),
                          ),
                          title: Text(
                            controller.favouritesongs[index].title,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Color.fromARGB(230, 241, 238, 238)),
                          ),
                          subtitle: Text(
                            controller.favouritesongs[index].artist ??
                                'unknown',
                            style: const TextStyle(color: Colors.white30),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  middleText:
                                      "Do you want to remove this song?",
                                  onCancel: () {
                                    Get.back();
                                  },
                                  textConfirm: "Remove",
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    controller.deletefav(index);
                                    Get.back();
                                    Get.snackbar("Removed from Liked Songs", "",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.white,
                                        margin: const EdgeInsets.all(40),
                                        duration: const Duration(seconds: 1));
                                  },
                                  cancelTextColor:
                                      const Color.fromARGB(255, 45, 141, 0),
                                  buttonColor:
                                      const Color.fromARGB(255, 249, 45, 26));
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  });
            },
          ),
        ));
  }
}
