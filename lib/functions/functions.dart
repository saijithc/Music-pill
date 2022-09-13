import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/view/home.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Dbfunctions extends GetxController {
  List<SongModel> favouritesongs = [];
  List<dynamic> favmodels = [];
  dynamic favsongids;
  addsong(item) async {
    final boxdb = await Hive.openBox('favourite');
    await boxdb.add(item);
    //update();
    getAllsongs();
  }

  static resetfav() async {
    final boxdb = await Hive.openBox('favourite');
    boxdb.clear();
  }

  getAllsongs() async {
    final boxdb = await Hive.openBox('favourite');
    favsongids = boxdb.values.toList();
    displaySongs();
  }

  deletefav(id) async {
    final boxdb = await Hive.openBox('favourite');
    await boxdb.deleteAt(id);
    getAllsongs();
  }

  displaySongs() async {
    final boxdb = await Hive.openBox('favourite');
    final dynamic music = boxdb.values.toList();
    favmodels.clear();
    favouritesongs.clear();
    for (int i = 0; i < music.length; i++) {
      for (int j = 0; j < Home.songs.length; j++) {
        if (music[i] == Home.songs[j].id) {
          favouritesongs.add(Home.songs[j]);
          favmodels.add(j);
        }
      }
    }
    update();
  }

//<<..............functions for playlist folder..............>>
  List<PlaylistsModel> playlist = [];
  //dynamic plysongs;
  addtoplaylist(PlaylistsModel item) async {
    final boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
    await boxplaylist.add(item);
    getAllplaylist();
  }

  getAllplaylist() async {
    final boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
    // plysongs = boxplaylist.values.toList();
    playlist = boxplaylist.values.toList();
    update();
  }

  deleteplaylist(index) async {
    var boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
    await boxplaylist.deleteAt(index);
    getAllplaylist();
  }

  static resetplaylist() async {
    var boxplaylist = await Hive.openBox<PlaylistsModel>('playlist');
    boxplaylist.clear();
  }

  updateplaylist(index, item) async {
    final playlistdb = await Hive.openBox<PlaylistsModel>('playlist');
    await playlistdb.putAt(index, item);
    await getAllplaylist();
    await showsongs(index);
  }

//<<<<<<<....................FUNCTIONS FOR PLAYLIST SONGS.......................>>>>//
// List <dynamic> playlistsongs = [];
  List<SongModel> playlistmodels = [];
  showsongs(index) async {
    final songslist = playlist[index].playlistsongs;
    playlistmodels.clear();
    // playlistsongs.clear();
    for (int i = 0; i < songslist.length; i++) {
      for (int j = 0; j < Home.songs.length; j++) {
        if (songslist[i] == Home.songs[j].id) {
          // playlistsongs.add(j);
          playlistmodels.add(Home.songs[j]);
          break;
        }
      }
    }
    update();
  }
}
