import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/favorite_check.dart';
import 'package:music/functions/functions.dart';
import 'package:music/pages/check_playlist.dart';
import 'package:music/pages/home.dart';
import 'package:music/pages/library.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class NowPlaying extends StatefulWidget {
static final AudioPlayer player = AudioPlayer();
NowPlaying({Key? key , this.songlist }) : super(key: key);
static int currentIndex = 0;
List<SongModel>?songlist ;
static List<SongModel>?  playingdetails = []; 
static List<SongModel>?  finallist = []; 

@override
 State<NowPlaying> createState() => _NowPlayingState();
}
class _NowPlayingState extends State<NowPlaying> {
  
  //<<...................duration state stream......................>>
  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>( NowPlaying.player.positionStream,NowPlaying.player.durationStream,
          (position, duration) => DurationState( position: position, total: duration ?? Duration.zero));
  @override
  void initState() {   
    NowPlaying.playingdetails!.clear();
    for (var i = 0; i < widget.songlist!.length; i++) {
     NowPlaying.playingdetails!.add(widget.songlist![i]);     
    }    
  // NowPlaying.songscopy.addAll(widget.songlist!);  
   Dbfunctions.getAllsongs(); 
    super.initState();
 //<<...............update the current playing song index..................>>
    NowPlaying.player.currentIndexStream.listen((index) {
      if (index != null) {  
        _updateCurrentPlaying(index);
      }
    });    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: (IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Dbfunctions.getAllsongs();
          },
          icon: const Icon(Icons.keyboard_arrow_down),
        )),
        title: const Text(
          'Now Playing',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox( width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.height * 0.33,
              child: GestureDetector(onHorizontalDragEnd:(dragDownDetails){if(dragDownDetails.primaryVelocity! < 0 ){
                  if(NowPlaying.player.hasNext){ NowPlaying.player.seekToNext();
                    setState(() {   
                    });
                  }
                }else if(dragDownDetails.primaryVelocity!>0){
                  if(NowPlaying.player.hasPrevious){ NowPlaying.player.seekToPrevious();
                    setState(() { });
                  }
                }} ,
                child: QueryArtworkWidget( id: widget.songlist![NowPlaying.currentIndex].id,type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.fitWidth, artworkHeight: 60, artworkQuality: FilterQuality.high,artworkBorder: BorderRadius.circular(15), size: 500,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                   child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20,top: 20),
                    child: Text( widget.songlist![NowPlaying.currentIndex].title, style: const TextStyle( color: Colors.white, fontWeight: FontWeight.w700), ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,right: 50),
                  child: Text( widget.songlist![NowPlaying.currentIndex].artist ?? 'unknown',style: const TextStyle( color: Color.fromARGB(255, 159, 158, 158),overflow: TextOverflow.ellipsis),
                  ),
                ),SizedBox(height: MediaQuery.of(context).size.height*0.03,),
    //<<...........................Library icon and Favourite....................................>>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [IconButton(onPressed: () {
                        Dbfunctions.getAllplaylist();
    //<<<<<<<<....................................BOTTOMSHEET CREATION FOR ADDING SONGS TO THE AVAILABLE PLAYLIST......................>>>>>>>>>>>>
                          showModalBottomSheet(backgroundColor: Colors.transparent,
                            context: context, builder: (context){
                            return Column(mainAxisAlignment: MainAxisAlignment.end,
                              children: [const Text('Add to playlist',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontSize: 15,fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25,right: 25),
                                  child: InkWell(onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> Library()));
                                  },
                                    child: Container( height: MediaQuery.of(context).size.height*0.50,width: double.infinity,decoration: const BoxDecoration(color: Color.fromARGB(255, 252, 254, 254),borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),child: ValueListenableBuilder(
                                      valueListenable: Dbfunctions.playlist,
                                      builder: (BuildContext context, List<dynamic> value, Widget? child) {
                                        if(value.isEmpty){
                                          return Container(decoration: const BoxDecoration(image:DecorationImage(image:AssetImage('assets/waiting.gif'),fit: BoxFit.cover ) ),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children:  [const SizedBox(height: 5,),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Text('Oops! No Playlist Found',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: Text('Tap to create new playlist',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),),
                                                ),
                                              ],
                                            ),
                                          );
                                  
                                        }
                                        return  ListView.builder( itemCount:Dbfunctions.playlist.value.length,itemBuilder: (context,index){
                                         return Padding(padding: const EdgeInsets.only(top: 20),
                                          child: ListTile( leading:  Container( width: MediaQuery.of(context).size.width * 0.18, height: MediaQuery.of(context).size.height * 0.19,
                                          decoration: const BoxDecoration( image: DecorationImage(image: AssetImage('assets/logo.jpg'), fit: BoxFit.cover),), ),
                                          title: Text(Dbfunctions.playlist.value[index].foldername!.toUpperCase(),style: const TextStyle(color: Colors.black,fontSize: 16),),
                                          subtitle: const Text('Playlist',style: TextStyle(fontSize: 12),),
                                          trailing: CheckPlaylist(index:NowPlaying.currentIndex, folderindex:index, id:widget.songlist![NowPlaying.currentIndex].id),),  ); });
                                      },
                                    )),
                                  ),
                                )],);

                          });
     //<<<<<<<<<<<<<...............................END OF BOTTOMSHEET FOR ADDING SONGS TO THE AVAILABLE PLAYLIST FOLDERS...........................>>>>>>>>>>>>
                        },
                        icon: const Icon(Icons.playlist_add,color: Colors.white54, size: 30, )),
                     FavCheck(id: widget.songlist![NowPlaying.currentIndex].id, ),
                     Flexible(child: InkWell(onTap: (){
                       NowPlaying.player.loopMode == LoopMode.one? NowPlaying.player.setLoopMode(LoopMode.all):NowPlaying.player.setLoopMode(LoopMode.one);

                     },
                     child: StreamBuilder<LoopMode>(stream: NowPlaying.player.loopModeStream,builder: (context,snapshot){
                       final loopmode = snapshot.data;
                       if(LoopMode.one == loopmode){
                         return const Icon(Icons.repeat_one,color: Colors.green,);
                       }else{
                         return const Icon(Icons.repeat,color: Colors.white54,);
                       }
                     },),
                     ))
                    
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
     //<<......................Slider creation...........................>>
                Column(
                  children: [
       //<<.............slider bar container.....................>>
                    Container(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      margin: const EdgeInsets.only(bottom: 4.0),
     //<<.............    slider bar duration state   ...............................>>
                      child: StreamBuilder<DurationState>(
                          stream: durationStateStream,
                          builder: (context, snapshot) {
                            final durationState = snapshot.data;
                            final progress = durationState?.position ?? Duration.zero;
                            final total = durationState?.total ?? Duration.zero;

                            return ProgressBar(
                              progress: progress,
                              total: total,
                              barHeight: 3,
                              progressBarColor: const Color.fromARGB(255, 151, 234, 153),
                              baseBarColor: const Color.fromARGB(255, 207, 208, 208),
                              thumbColor:  const Color.fromARGB(255, 2, 241, 193),  
                              timeLabelPadding: 8,                                          
                              timeLabelTextStyle: const TextStyle(color: Colors.white),
                              onSeek: (duration) {NowPlaying.player.seek(duration); },
                            );
                          }),
                    ),
                  ],
                ),
      //<<..............................buttons creation [PREVIOUS / PLAY / PAUSE / NEXT ]...................>>
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
     //<<<..................................previous button .....................>>>
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            if (NowPlaying.player.hasPrevious) {
                              await NowPlaying.player.seekToPrevious();
                              setState(() {});
                            } 
                            else {
                              NowPlaying.currentIndex = widget.songlist!.length - 1;
                              await NowPlaying.player.play();
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: getDecoration( BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                            child: const Icon( Icons.skip_previous,color: Colors.white70, ),
                          ),
                        ),
                      ),
          //<<.......................play pause......................................>>
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            if (NowPlaying.player.playing) {
                              NowPlaying.player.pause();
                            } else {
                              if (NowPlaying.player.currentIndex != null) {
                                NowPlaying.player.play();                               
                              }
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                              child: StreamBuilder<bool>( stream: NowPlaying.player.playingStream,
                                builder: (context, snapshot) {
                                  bool? playingState = snapshot.data;
                                  if (playingState != null && playingState) {
                                    return const Icon( Icons.pause,  size: 40, color: Colors.white, );
                                  }
                                  return const Icon( Icons.play_arrow,size: 40,color: Colors.white, );
                                },
                              )),
                        ),
                      ),
            //<<................................next song .........................>>
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            if (NowPlaying.player.hasNext) {
                              await NowPlaying.player.seekToNext();
                              setState(() {});
                            } else {
                              NowPlaying.currentIndex = 0;
                              await NowPlaying.player.play();
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: getDecoration( BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                            child: const Icon( Icons.skip_next, color: Colors.white70,  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  _updateCurrentPlaying(int index) {
    setState(() {
      if (NowPlaying.player.currentIndex != null) {
        NowPlaying.currentIndex = NowPlaying.player.currentIndex!;
      }
    });
  }
  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: const Color.fromARGB(255, 108, 209, 128),
      shape: shape,
    );
  }
}
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
