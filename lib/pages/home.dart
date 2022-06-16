import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:music/favorite_check.dart';
import 'package:music/functions/functions.dart';
import 'package:music/pages/concatinating.dart';

import 'package:music/pages/now_playing.dart';
import 'package:music/pages/about.dart';
import 'package:music/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static List<SongModel> songs = [];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  bool isPlayerViewVisible = false;

  @override
  void initState() {
    
    super.initState();
    requestStorapermission();
 Dbfunctions.displaySongs();
    
  }

  @override
  Widget build(BuildContext context) {
    Dbfunctions.getAllsongs();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
        child: ListView(
          children: [
            AppBar(actions: [PopupMenuButton(
  child: const Center(child: Padding(
    padding: EdgeInsets.only(right: 15),
    child: Icon(Icons.more_vert),
  )),
  itemBuilder: (context) {
    return 
    List.generate(1, (index) {
      return PopupMenuItem(
        child: Column(
          children: [
            ListTile(leading: const Text('About'),onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const About()));},),
            const Divider(),
            ListTile(leading: const Text('Reset App'),onTap: (){
              showDialog( context: context,builder: (ctx) {
                          return Column( mainAxisAlignment: MainAxisAlignment.center,children: [ AlertDialog( backgroundColor: Colors.white,
                             content:  Center(child: Column(
                               children:  [
                                 const Text( 'Do you want to reset your app ?', style: TextStyle( color: Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.w700), ),SizedBox(height: MediaQuery.of(context).size.height*0.02,),const Text('All your playlist and favourite songs will be lost !',style: TextStyle(fontSize: 12,color: Color.fromARGB(255, 254, 155, 6)),)
                               ],
                             ), ),
                                 actions: [ Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     children: [ ElevatedButton( onPressed: () { Navigator.of(context) .pop(); },
                                         child: const Text('Cancel', style: TextStyle(color: Colors.white), )),
                                            ElevatedButton( onPressed: ()  { 
                                                 Dbfunctions.resetfav();NowPlaying.player.pause(); Dbfunctions.resetplaylist();Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const Splash()));
                                               
                                                  },
                                                  child: const Text( 'Reset', style: TextStyle( color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  });
              
              },),
            
          ],
        ),
      );
    }
    );
  },
),
  
                ],
              backgroundColor: Colors.transparent,
              title: const Text( 'Uniquely yours', style: TextStyle(color: Colors.white),), ),
            FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true),
              builder: (context, item) {
                if (item.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (item.data!.isEmpty) {
                  return  Center(
                    child: Column(
                      children: [SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                        const Text('No Songs Found !',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 50)),
                      ],
                    ),
                  );
                }

                //<<................add songs to the song list.............>>

                Home.songs.clear();
                Home.songs = item.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(mainAxisExtent: 200, maxCrossAxisExtent: 200, childAspectRatio: 1, crossAxisSpacing: 8, mainAxisSpacing: 0),
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
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.13,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                    ),
                                    child: QueryArtworkWidget( id: item.data![index].id, type: ArtworkType.AUDIO, artworkFit: BoxFit.cover, artworkBorder: BorderRadius.circular(15), ),
                                  ),
                                ),
                                Text( item.data![index].title,style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis), ),
                                Row( mainAxisAlignment: MainAxisAlignment.end, children: [
                                    FavCheck( id: Home.songs[index].id, ),
                                  ],
                                )                             
                              ],
                            ),
                          ),
                          onTap: () {
                            NowPlaying.player.setAudioSource(Concatinatig.createPlaylist(Home.songs),initialIndex: index);
                            NowPlaying.player.play();
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>  NowPlaying(songlist: Home.songs,))).whenComplete((){setState(() {
                              
                            });});
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  void requestStorapermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }
}
