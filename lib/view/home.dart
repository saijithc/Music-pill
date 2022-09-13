import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:music/view/favorite_check.dart';
import 'package:music/functions/functions.dart';
import 'package:music/view/concatinating.dart';
import 'package:music/view/now_playing.dart';
import 'package:music/view/pop_up.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/home/home_controller.dart';
import '../controller/nowplaying/nowplaying_controller.dart';

class Home extends GetView {
  Home({Key? key}) : super(key: key);
  static List<SongModel> songs = [];
  final homecontroller = Get.put(HomeController());
  final playercontroller = Get.put(NowPlayingController());
  @override
  final controller = Get.put(Dbfunctions());
  final bool isPlayerViewVisible = false;
  @override
  Widget build(BuildContext context) {
//controller.getAllsongs();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
        child: ListView(
          children: [
            AppBar(
              actions: [
                PopupMenuButton(
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.more_vert),
                  )),
                  itemBuilder: (context) {
                    return List.generate(1, (index) {
                      return PopupMenuItem(child: PopUp());
                    });
                  },
                ),
              ],
              backgroundColor: Colors.transparent,
              title: const Text(
                'Uniquely yours',
                style: TextStyle(color: Colors.white),
              ),
            ),
            GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return FutureBuilder<List<SongModel>>(
                    future: homecontroller.audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true),
                    builder: (context, item) {
                      if (item.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (item.data!.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              const Text('No Songs Found !',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 50)),
                            ],
                          ),
                        );
                      }

                      //<<................add songs to the song list.............>>

                      Home.songs.clear();
                      Home.songs = item.data!;
                      // return GetBuilder<Dbfunctions>(builder: (controller) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisExtent: 200,
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 0),
                        itemCount: item.data!.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext ctx, index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: InkWell(
                                child: Card(
                                  color: Colors.transparent,
                                  child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Center(
                                        child: Container(
                                          height:
                                              MediaQuery.of(ctx).size.height *
                                                  0.13,
                                          width: MediaQuery.of(ctx).size.width *
                                              0.4,
                                          decoration: const BoxDecoration(
                                            borderRadius:
                                                BorderRadius.all(Radius.zero),
                                          ),
                                          child: QueryArtworkWidget(
                                            nullArtworkWidget: Image.asset(
                                              "assets/logo.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                            id: item.data![index].id,
                                            type: ArtworkType.AUDIO,
                                            artworkFit: BoxFit.cover,
                                            artworkBorder:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.data![index].title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GetBuilder<Dbfunctions>(
                                              init: Dbfunctions(),
                                              builder: (context) {
                                                return FavCheck(
                                                  id: Home.songs[index].id,
                                                );
                                              }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  playercontroller.player.setAudioSource(
                                      Concatinatig.createPlaylist(Home.songs),
                                      initialIndex: index);
                                  playercontroller.mainList.clear();
                                  // NowPlaying.songlists.clear();
                                  playercontroller.addSong(Home.songs);
                                  playercontroller.player.play();

                                  // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>  NowPlaying(songlist: Home.songs,))).whenComplete((){setState(() { });});
                                  Get.to(NowPlaying());
                                },
                              ),
                            ),
                          );
                        },
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
