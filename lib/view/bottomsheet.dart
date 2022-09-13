import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/view/home.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../functions/functions.dart';
import 'check_playlist.dart';

class BottomSheetScreen extends StatelessWidget {
  BottomSheetScreen({Key? key, required this.folderindex}) : super(key: key);
  final int folderindex;
  final Dbfunctions controller = Get.put(Dbfunctions());
  @override
  Widget build(BuildContext context) {
    return TextButton(
        //<<........................BOTTOM SHEET SONG LIST CREATION..................>>//
        onPressed: () {
          controller.getAllplaylist();
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 243, 243, 243),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0))),
                    height: 450,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GetBuilder<Dbfunctions>(
                          init: Dbfunctions(),
                          builder: (controller) {
                            return ListView.builder(
                                //shrinkWrap: true,
                                itemCount: Home.songs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListTile(
                                        leading: QueryArtworkWidget(
                                            nullArtworkWidget: Image.asset(
                                              "assets/logo.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                            artworkWidth: 60,
                                            artworkBorder:
                                                BorderRadius.circular(0),
                                            artworkFit: BoxFit.cover,
                                            id: Home.songs[index].id,
                                            type: ArtworkType.AUDIO),
                                        title: Text(
                                          Home.songs[index].title,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        trailing: CheckPlaylist(
                                          id: Home.songs[index].id,
                                          folderindex: folderindex,
                                          index: index,
                                        )),
                                  );
                                });
                          }),
                    ),
                  ));
            },
          );
        },
//<<<.......................END OF BOTTOMSHEET SONGS LIST CREATION.....................>>>//
        child: const Text(
          'ADD SONGS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            backgroundColor: Colors.green,
          ),
        ));
  }
}
