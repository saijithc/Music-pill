import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/view/concatinating.dart';
import 'package:music/view/bottomsheet.dart';
import 'package:music/view/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/nowplaying/nowplaying_controller.dart';

class PlayList extends GetView {
  PlayList({Key? key, required this.name, required this.folderindex})
      : super(key: key);
  final dynamic name;
  final int folderindex;
  final List<dynamic> songlists = [];
  final RxList<dynamic> afterdeletelist = [].obs;
  @override
  final controller = Get.put(Dbfunctions());
  final playercontroller = Get.put(NowPlayingController());
  @override
  Widget build(BuildContext context) {
    controller.showsongs(folderindex);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          controller.playlist[folderindex].foldername!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [BottomSheetScreen(folderindex: folderindex)],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: GetBuilder<Dbfunctions>(
          init: Dbfunctions(),
          builder: (controller) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.playlist[folderindex].playlistsongs.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListTile(
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
                              id: controller.playlistmodels[index].id,
                              type: ArtworkType.AUDIO),
                        ),
                        title: Text(
                          controller.playlistmodels[index].title,
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  title: "Do you want to remove this song?",
                                  middleText: "",
                                  onCancel: () {
                                    Get.back();
                                  },
                                  onConfirm: () {
                                    controller
                                        .playlist[folderindex].playlistsongs
                                        .removeAt(index);
                                    afterdeletelist.value = [
                                      songlists,
                                      controller
                                          .playlist[folderindex].playlistsongs
                                    ].expand((element) => element).toList();
                                    final model = PlaylistsModel(
                                        foldername: controller
                                            .playlist[folderindex].foldername,
                                        playlistsongs: afterdeletelist);
                                    controller.updateplaylist(
                                        folderindex, model);
                                    Get.back();
                                    Get.snackbar(" Removed ",
                                        "One song removed from this playlist",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: const Color.fromARGB(
                                            255, 133, 252, 177),
                                        margin: const EdgeInsets.all(35),
                                        duration: const Duration(seconds: 1));
                                  });
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.red,
                            )),
                        onTap: () {
                          playercontroller.player.setAudioSource(
                              Concatinatig.createPlaylist(
                                  controller.playlistmodels),
                              initialIndex: index);
                          playercontroller.player.play();
                          playercontroller.mainList.clear();
                          playercontroller.addSong(controller.playlistmodels);
                          Get.to(NowPlaying());
                        },
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
