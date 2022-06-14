import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';

import 'package:music/pages/home.dart';
import 'package:music/pages/library.dart';
import 'package:music/pages/now_playing.dart';
import 'package:music/search.dart';
import 'package:music/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<void> main() async {
   //<<.....................app rotation of............>>
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //<<<<<<<<.....................backgroundplay.................>>>>>>>>>>>>>>    
   await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
 
     
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(PlaylistsModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistsModelAdapter());
  }
  Dbfunctions.getAllsongs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}

// ignore: must_be_immutable
class Mainhome extends StatefulWidget {
   Mainhome({Key? key}) : super(key: key);
 List<SongModel>?  finallist = []; 
  @override
  
  State<Mainhome> createState() => _MainHomeState();
}


class _MainHomeState extends State<Mainhome> {
  @override
  void initState() {
    super.initState();
    NowPlaying.player.currentIndexStream.listen((event) {if(event!=null){setState(() {});} });
  }
  
  int selectedIndex = 0;
  PageController controller = PageController();
  
  @override
  
  
  Widget build(BuildContext context) {
    
    return Scaffold(
         extendBody: true,
        body: PageView(
          children: <Widget>[
            const Home(),
            const Search(),
            Library(),
          ],
          controller: controller,
          onPageChanged: (page) {
            setState(() {
              selectedIndex = page;
            });
          },
        ),
        bottomNavigationBar: Stack(
          children:[SizedBox(height: 160,
            child: Padding(
              padding: const EdgeInsets.only(top:60),
              child: BottomNavigationBar(
                unselectedItemColor: const Color.fromARGB(153, 156, 151, 151),
                currentIndex: selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: Colors.black,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      activeIcon: CircleAvatar(
                        radius: MediaQuery.of(context).size.aspectRatio * 40,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage('assets/bottom.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      icon: const Icon(Icons.home),
                      label: ''),
                  BottomNavigationBarItem(
                      activeIcon: CircleAvatar(radius: MediaQuery.of(context).size.aspectRatio*60,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: const Icon(
                            Icons.search,
                            size: 50,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage('assets/bottom.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      icon: const Icon(Icons.search),
                      label: ''),
                  BottomNavigationBarItem(
                      activeIcon: CircleAvatar(
                        radius: MediaQuery.of(context).size.aspectRatio * 40,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: const Icon(
                            Icons.music_note_outlined,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage('assets/bottom.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(28)),
                        ),
                      ),
                      icon: const Icon(Icons.music_note_outlined,),
                      label: ''),
                ],
              ),
            ),
          ),Positioned(
            
       //<<<<<<<<<<<<<<<<<......................***.MINI PLAYER SCREEN CREATION.***..................>>>>>>>>>>>>>>>>>>>
            
            child: NowPlaying.player.currentIndex!=null||NowPlaying.player.playing?
           Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
             child: InkWell(child:
              Container(height: 60,width: double.infinity,decoration:  BoxDecoration(color:const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),borderRadius: BorderRadius.circular(16),  ),child: GestureDetector(onHorizontalDragEnd: (dragDownDetails){
                if(dragDownDetails.primaryVelocity! < 0 ){
                  if(NowPlaying.player.hasNext){
                    NowPlaying.player.seekToNext();
                    setState(() {
                      
                    });
                  }

                }else if(dragDownDetails.primaryVelocity!>0){
                  if(NowPlaying.player.hasPrevious){
                    NowPlaying.player.seekToPrevious();
                    setState(() {
                      
                    });
                  }
                }
              },
                child: 
                ListTile(title: SizedBox(child: Marquee( text:NowPlaying.playingdetails![NowPlaying.player.currentIndex!].title,pauseAfterRound: const Duration(seconds: 10),velocity: 30,)),
                leading: CircleAvatar(child: QueryArtworkWidget(id:NowPlaying.playingdetails![NowPlaying.player.currentIndex!].id, type: ArtworkType.AUDIO,artworkFit: BoxFit.cover,)),
                trailing:   InkWell( onTap: () async {
                    if (NowPlaying.player.playing) {
                      NowPlaying.player.pause();
                    } else {
                      if (NowPlaying.player.currentIndex != null) {
                        NowPlaying.player.play();
                      }
                    }
                  },
     //<<<<<<<<..........................PLAY PAUSE BUTTON CREATION.. ........................>>>>>               
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: getDecoration(BoxShape.circle,
                          const Offset(2, 2), 2.0, 0.0),
                      child: StreamBuilder<bool>(
                        stream: NowPlaying.player.playingStream,
                        builder: (context, snapshot) {
                          bool? playingState = snapshot.data;
                          if (playingState != null && playingState) {
                            return const Icon(
                              Icons.pause,
                              size: 20,
                              color: Colors.white,
                            );
                          }
                          return const Icon(
                            Icons.play_arrow,
                            size: 20,
                            color: Colors.white,
                          );
                        },
                      )),
                ),
                ),
              ),),
              
              onTap:(){
                
                for (var i = 0; i < NowPlaying.playingdetails!.length; i++) {
                  widget.finallist!.add(NowPlaying.playingdetails![i]);
                  
                }
               Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>  NowPlaying(songlist: widget.finallist!)));
             } ,),
          ):const Text('') 
 //<<<<<<<<<<<<<<<<<<<<<<................ENDING OF MINIPLAYER SCREEN CREATION..........................................>>>>>>>>>>>>>>   
          )]
        ));
  }

  _onItemTapped(int index) {
    setState(
      () {
        selectedIndex = index;
        controller.jumpToPage(index);
      },
    );
  }
  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: const Color.fromARGB(255, 93, 212, 116),
      shape: shape,
    );
  }
}



