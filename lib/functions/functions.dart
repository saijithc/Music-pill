import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/pages/home.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Dbfunctions {
  static ValueNotifier<List<SongModel>> favouritesongs = ValueNotifier([]);
  static ValueNotifier <List<dynamic>> favmodels= ValueNotifier([]);
  static dynamic favsongids;
  static addsong(item) async {
    final boxdb = await Hive.openBox('favourite');
    await boxdb.add(item);
    getAllsongs();
  }
static resetfav()async{
  final boxdb = await Hive.openBox('favourite');
  boxdb.clear();
}
  static getAllsongs() async {
    final boxdb = await Hive.openBox('favourite');
    favsongids = boxdb.values.toList();
    displaySongs();
    favouritesongs.notifyListeners();
  }

  static deletefav(id) async {
    final boxdb = await Hive.openBox('favourite');
    await boxdb.deleteAt(id);
    getAllsongs();
  }

  static displaySongs() async {
    final boxdb = await Hive.openBox('favourite');
    final dynamic music = boxdb.values.toList();
    favmodels.value.clear();
    favouritesongs.value.clear();
    for (int i = 0; i < music.length; i++) {
      for (int j = 0; j < Home.songs.length; j++) {
        if (music[i] == Home.songs[j].id) {
          favouritesongs.value.add(Home.songs[j]);
          favmodels.value.add(j);
        }
      }
    }  
    favmodels.notifyListeners();
// for(int i=0 ; i< favouritesongs.value.length; i++ ){
//   favmodels.add(Home.songs[favouritesongs.value[i]]);
} 

  

//<<..............functions for playlist folder..............>>

  static ValueNotifier<List<PlaylistsModel>> playlist = ValueNotifier([]);
  
  static dynamic plysongs;
  static addtoplaylist(PlaylistsModel item) async {
    final boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
    await boxplaylist.add(item);
    getAllplaylist();
  }

  static getAllplaylist() async {
    final boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
    plysongs = boxplaylist.values.toList();
    playlist.value.clear();
    playlist.value.addAll(boxplaylist.values);
    playlist.notifyListeners();
  }

  static deleteplaylist(index) async {
    var boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
    await boxplaylist.deleteAt(index);
    getAllplaylist();
  }
  static resetplaylist()async{
   var boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
   boxplaylist.clear();
  }

  static updateplaylist(index, item) async {
    final playlistdb = await Hive.openBox<PlaylistsModel>('playlist');
    await playlistdb.putAt(index, item);
    await getAllplaylist();
    await PlaylistsongsFunctions.showsongs(index);
  }
//<<<<<<<....................FUNCTIONS FOR PLAYLIST SONGS.......................>>>>//


}

class PlaylistsongsFunctions {
  static ValueNotifier<List<dynamic>> playlistsongs = ValueNotifier([]);
   static ValueNotifier <List<SongModel>> playlistmodels= ValueNotifier([]);
  static showsongs(index) async {
    final songslist = Dbfunctions.playlist.value[index].playlistsongs;
    playlistmodels.value.clear();
    playlistsongs.value.clear();
    for (int i = 0; i < songslist.length; i++) {
      for (int j = 0; j < Home.songs.length; j++) {
        if (songslist[i] == Home.songs[j].id) {
          playlistsongs.value.add(j);
          playlistmodels.value.add(Home.songs[j]);
          
          break;
        }
      }
    }
    playlistmodels.notifyListeners();
  }
}
