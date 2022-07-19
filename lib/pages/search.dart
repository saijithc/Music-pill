import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/pages/concatinating.dart';
import 'package:music/pages/home.dart';
import 'package:music/pages/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/nowplaying/nowplaying_controller.dart';
// ValueNotifier<List<SongModel>> temp = ValueNotifier([]);

class Search extends GetView {
   Search({Key? key}) : super(key: key);
  static dynamic searchindex = [];
  final  Rx<RxList<SongModel>> temp = RxList<SongModel>([]).obs;
  final playercontroller = Get.put(NowPlayingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.13,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextField(
            onChanged: (String? value) {
              if (value == null || value.isEmpty) {
                temp.value.addAll(Home.songs);
              } else {
                temp.value.clear();
                for (SongModel i in Home.songs) {
                  if (i.title.toLowerCase().contains(value.toLowerCase())) {
                    temp.value.add(i);
                  }
                }
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              prefixIcon: const Icon(Icons.search),filled: true, fillColor: Colors.white, hintText: 'Songs',
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    child: Obx(
                      (() => ListView.builder( itemCount: temp.value.length,
                       itemBuilder: (context, index) {final data = temp.value[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: ListTile(
                                  leading: QueryArtworkWidget( artworkWidth: 60,artworkBorder: BorderRadius.circular(0),
                                      artworkFit: BoxFit.cover,id: data.id,type: ArtworkType.AUDIO),
                                  title: Text(data.title,style: const TextStyle(color:Color.fromARGB(255, 170, 170, 170))),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    int songindex =indexpassing(temp.value, index);
                                    playercontroller.player.setAudioSource(Concatinatig.createPlaylist(Home.songs),initialIndex: songindex);
                                    playercontroller.player.play();
                                    Get.to(NowPlaying( NowPlaying.songlists.addAll(Home.songs)
                                      // songlist: Home.songs, 
                                      ));
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  NowPlaying(songlist: Home.songs,)));
                                  },
                                ),
                              );
                            },
                          )),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
indexpassing(data, index) {
  int? searchindex;
  for (int i = 0; i < Home.songs.length; i++) {
    if (data[index].id == Home.songs[i].id) {
      searchindex = i;
    }
  }
  return searchindex;
}
