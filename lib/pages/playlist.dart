import 'package:flutter/material.dart';

import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';

import 'package:music/pages/check_playlist.dart';
import 'package:music/pages/concatinating.dart';
import 'package:music/pages/home.dart';
import 'package:music/pages/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class PlayList extends StatefulWidget {
  PlayList({Key? key, required this.name, required this.folderindex})
      : super(key: key);
  dynamic name;
  int folderindex;

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  List<dynamic> afterdeletelist = [];
  List<dynamic> songlists = [];

  @override
  Widget build(BuildContext context) {
    PlaylistsongsFunctions.showsongs(widget.folderindex);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          Dbfunctions.playlist.value[widget.folderindex].foldername!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(

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
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 243, 243, 243),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(50.0))),
                        height: 450,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              itemCount: Home.songs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListTile(
                                      leading: QueryArtworkWidget(
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
                                        folderindex: widget.folderindex,
                                        index: index,
                                      ),
                                    ));
                              }),
                        ),
                      ),
                    );
                  },
                ).whenComplete((){
                  setState(() {
                    
                  });
                });

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
        child: ValueListenableBuilder(
          valueListenable: PlaylistsongsFunctions.playlistsongs,
          builder: (BuildContext context, List<dynamic> values, Widget? child) {
            return ListView.builder(
              itemCount: Dbfunctions.playlist.value[widget.folderindex].playlistsongs.length,
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
                              id: Home
                                  .songs[PlaylistsongsFunctions
                                      .playlistsongs.value[index]]
                                  .id,
                              type: ArtworkType.AUDIO),
                        ),
                        title: Text(
                          Home
                              .songs[PlaylistsongsFunctions
                                  .playlistsongs.value[index]]
                              .title,
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
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
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 215, 255, 250),
                                            content: const Center(
                                                child: Text(
                                              'Do you wanna remove this song?',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 85, 85),
                                              ),
                                            )),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ElevatedButton( onPressed: () {Navigator.of(context).pop();},
                                                      child: const Center(
                                                          child: Text( 'Cancel', style: TextStyle(color: Colors.white),
                                                      ))),
                                                  ElevatedButton( onPressed: () {setState(() {}); Dbfunctions.playlist .value[widget.folderindex].playlistsongs .removeAt(index);

                                                        afterdeletelist = [ songlists, Dbfunctions .playlist.value[widget .folderindex].playlistsongs ].expand((element) => element).toList();
                                                        final model = PlaylistsModel( foldername: Dbfunctions.playlist.value[widget.folderindex].foldername,
                                                            playlistsongs: afterdeletelist);
                                                        Dbfunctions.updateplaylist( widget.folderindex, model);
                                                        Navigator.of(context) .pop();
                                                        ScaffoldMessenger.of(  context).showSnackBar(
                                                                const SnackBar(content: Text('Song removed from this playlist'),
                                                          margin: EdgeInsets.all( 30),
                                                          behavior: SnackBarBehavior.floating, ));
                                                      },
                                                      child: const Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ]);
                                  });
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.red,
                            )),
                        onTap: ()  { NowPlaying.player.setAudioSource(Concatinatig.createPlaylist(PlaylistsongsFunctions.playlistmodels.value), initialIndex: index);
                           NowPlaying.player.play();
                            Navigator.of(context).push(MaterialPageRoute( builder: (context) =>  NowPlaying(songlist: PlaylistsongsFunctions.playlistmodels.value),
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
      // floatingActionButton: IconButton(
      //     onPressed: () { setState(() {});  },
      //     icon: const Icon( Icons.refresh_outlined, color: Color.fromARGB(255, 9, 247, 172), size: 30, )),
    );
  }
}
