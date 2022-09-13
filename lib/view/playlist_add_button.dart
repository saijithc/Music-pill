import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/functions/functions.dart';
import 'package:music/view/check_playlist.dart';
import 'package:music/view/library.dart';
import 'package:music/view/now_playing.dart';
import '../controller/nowplaying/nowplaying_controller.dart';

class PlaylistButton extends StatelessWidget {
  PlaylistButton({Key? key}) : super(key: key);
  final nowController = Get.put(NowPlayingController());
  final controller = Get.put(Dbfunctions());
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return IconButton(
        onPressed: () {
          controller.getAllplaylist();
          //<<<<<<<<.............BOTTOMSHEET CREATION FOR ADDING SONGS TO THE AVAILABLE PLAYLIST......................>>>>>>>>>>>>
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Add to playlist',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: InkWell(
                        onTap: () {
                          Get.to(Library());
                        },
                        child: Container(
                            height: h * 0.50,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 252, 254, 254),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            child: GetBuilder<Dbfunctions>(
                              init: Dbfunctions(),
                              builder: (controller) {
                                if (controller.playlist.isEmpty) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/waiting.gif'),
                                            fit: BoxFit.cover)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Oops! No Playlist Found',
                                            style:
                                                TextStyle(fontSize: w * 0.05),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Tap to create new playlist',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.playlist.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: ListTile(
                                            leading: Container(
                                              width: w * 0.18,
                                              height: h * 0.19,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/logo.jpg'),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            title: Text(
                                              controller
                                                  .playlist[index].foldername!
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                            subtitle: const Text(
                                              'Playlist',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            trailing: CheckPlaylist(
                                                index: nowController
                                                    .player.currentIndex!,
                                                folderindex: index,
                                                id: nowController
                                                    .mainList[nowController
                                                        .player.currentIndex!]
                                                    .id)),
                                      );
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
        ));
  }
}
