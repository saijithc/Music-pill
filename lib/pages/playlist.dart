import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/pages/check_playlist.dart';
import 'package:music/pages/concatinating.dart';
import 'package:music/pages/home.dart';
import 'package:music/pages/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/nowplaying/nowplaying_controller.dart';
class PlayList extends GetView {
   PlayList({Key? key, required this.name, required this.folderindex }) : super(key: key);
  final dynamic name;
 final int folderindex;
  final List<dynamic> songlists = [];
 List<dynamic> afterdeletelist = [];
  @override
  final controller = Get.put(Dbfunctions());
  final playercontroller = Get.put(NowPlayingController());
  @override
  Widget build(BuildContext context) {
    controller.showsongs(folderindex);
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar( backgroundColor: Colors.black,
        title: Text( controller.playlist[folderindex].foldername!,
          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700, ),
        ),
        actions: [ TextButton(
              //<<........................BOTTOM SHEET SONG LIST CREATION..................>>//
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02),
                      child: Container(
                        decoration: const BoxDecoration( color: Color.fromARGB(255, 243, 243, 243),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0))),
                        height: 450,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child:
                          // GetBuilder<Dbfunctions>(
                          //   builder: (context) {
                          //     return
                               ListView.builder(itemCount: Home.songs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: ListTile(
                                          leading: QueryArtworkWidget( artworkWidth: 60,
                                              artworkBorder:BorderRadius.circular(0), artworkFit: BoxFit.cover,
                                              id: Home.songs[index].id,type: ArtworkType.AUDIO),
                                          title: Text( Home.songs[index].title, style: const TextStyle(
                                                color: Colors.black87, overflow: TextOverflow.ellipsis),
                                          ),
                                          trailing: GetBuilder<Dbfunctions>(
                                            builder: (context) {
                                              return CheckPlaylist(
                                                id: Home.songs[index].id, folderindex: folderindex,index: index,
                                              );
                                            }
                                          ),
                                        ));
                                  })
                          //   }
                          // ),
                        ),
                      ),
                    );
                  },
                );
                // .whenComplete((){
                 
                //   // setState(() {                    
                //   // });
                // });
              },
//<<<.......................END OF BOTTOMSHEET SONGS LIST CREATION.....................>>>//

              child: const Text(
                'ADD SONGS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  backgroundColor: Colors.green,
                ),
              ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        color: Colors.black,
        child: GetBuilder<Dbfunctions>(
          init: Dbfunctions(),
          builder:(controller)
        // ValueListenableBuilder(
        //   valueListenable: PlaylistsongsFunctions.playlistsongs,
        //   builder: (BuildContext context, List<dynamic> values, Widget? child)
           {
            return ListView.builder(
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
                              artworkFit: BoxFit.cover,
                              artworkBorder: BorderRadius.circular(2),
                              id: Home.songs[controller.playlistsongs[index]].id,
                              type: ArtworkType.AUDIO),
                        ),
                        title: Text( Home.songs[controller.playlistsongs[index]] .title,
                          style: const TextStyle( color: Colors.white,overflow: TextOverflow.ellipsis),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Get.defaultDialog(title: "Do you want to remove this song?",middleText: "",onCancel: (){Get.back();},
                              onConfirm: (){ controller.playlist [folderindex].playlistsongs .removeAt(index);
                                                         afterdeletelist = [ songlists, controller .playlist[ folderindex].playlistsongs ].expand((element) => element).toList();
                                                       final model = PlaylistsModel( foldername: controller.playlist[folderindex].foldername,
                                                      playlistsongs: afterdeletelist);
                                                        controller.updateplaylist( folderindex, model);Get.back();
                               Get.snackbar(" Removed ", "One song removed from this playlist",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 133, 252, 177),
                               margin:const EdgeInsets.all( 35),duration:const Duration(seconds: 1));
                            });
                              // showDialog( context: context,
                              //     builder: (ctx) {
                              //       return Column(  mainAxisAlignment: MainAxisAlignment.center,
                              //           children: [
                              //             AlertDialog(
                              //               backgroundColor: const Color.fromARGB( 255, 215, 255, 250),
                              //               content: const Center( child: Text(
                              //                 'Do you wanna remove this song?',
                              //                 style: TextStyle( color: Color.fromARGB( 255, 255, 85, 85),
                              //                 ),
                              //               )),
                              //               actions: [
                              //                 Row(
                              //                   mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                              //                   children: [
                              //                     ElevatedButton( onPressed: () {Get.back();},
                              //                         child: const Center(child: Text( 'Cancel', style: TextStyle(color: Colors.white),
                              //                         ))),
                              //                     ElevatedButton( onPressed: () {setState(() {}); controller.playlist [widget.folderindex].playlistsongs .removeAt(index);

                              //                           afterdeletelist = [ songlists, controller .playlist[widget .folderindex].playlistsongs ].expand((element) => element).toList();
                              //                           final model = PlaylistsModel( foldername: controller.playlist[widget.folderindex].foldername,
                              //                           playlistsongs: afterdeletelist);
                              //                           controller.updateplaylist( widget.folderindex, model);
                              //                           Get.back();
                              //                           // ScaffoldMessenger.of(  context).showSnackBar(
                              //                           //         const SnackBar(content: Text('Song removed from this playlist'),
                              //                           //   margin: EdgeInsets.all( 30),
                              //                           //   behavior: SnackBarBehavior.floating, ));
                              //                           Get.snackbar(" Removed ", "One song removed from this playlist",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 133, 252, 177));
                              //                         },
                              //                         child: const Text( 'Remove',style: TextStyle( color: Colors.white),
                              //                         ))
                              //                   ],
                              //                 )
                              //               ],
                              //             ),
                              //           ]);
                              //     });
                            },
                            icon: const Icon(  Icons.remove, color: Colors.red, )),
                        onTap: ()  { 
                          playercontroller.player.setAudioSource(Concatinatig.createPlaylist(controller.playlistmodels), initialIndex: index);
                           playercontroller.player.play();
                         Get.to(NowPlaying(
                          NowPlaying.songlists.addAll(controller.playlistmodels)
                          // songlist: controller.playlistmodels
                          ));
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
