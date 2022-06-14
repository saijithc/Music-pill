import 'package:flutter/material.dart';

import 'package:music/pages/concatinating.dart';
import 'package:music/pages/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../functions/functions.dart';

class LikedSongs extends StatelessWidget {
  const LikedSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dbfunctions.getAllsongs();

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
          child: ValueListenableBuilder(
            valueListenable: Dbfunctions.favouritesongs,
            builder:
                (BuildContext ctx, List<SongModel> favourList, Widget? child) {
              return ListView.builder(
                  itemCount: favourList.length,
                  itemBuilder: (ctx, index) {
                    
                    return Column(
                      children: [
                        ListTile(
                          onTap: ()   {
                           NowPlaying.player.setAudioSource(
                              Concatinatig.createPlaylist(favourList),
                                initialIndex: index);
                             NowPlaying.player.play();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  NowPlaying(songlist: favourList),
                            ));
                          },
                          leading: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: MediaQuery.of(context).size.height * 0.19,
                            child: QueryArtworkWidget(
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(2),
                                id: favourList[index].id,
                                type: ArtworkType.AUDIO),
                          ),
                          title: Text(
                           favourList[index].title,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Color.fromARGB(230, 241, 238, 238)),
                          ),
                          subtitle: Text(
                            favourList[index].artist ?? 'unknown',
                            style: const TextStyle(color: Colors.white30),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          content: const Center(
                                            child: Text(
                                              'Do you wanna remove this song?',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      await Dbfunctions
                                                          .deletefav(index);
                                                          
                                                      Navigator.of(context)
                                                          .pop();
                                                          
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            'Removed from Liked Songs'),
                                                        margin:
                                                            EdgeInsets.all(30),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ));
                                                    },
                                                    child: const Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),)
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                             
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
