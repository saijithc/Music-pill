import 'package:flutter/material.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/pages/home.dart';

// ignore: must_be_immutable
class CheckPlaylist extends StatefulWidget {
  CheckPlaylist( {Key? key, required this.index,required this.folderindex, required this.id}) : super(key: key);
  dynamic index;
  int folderindex;
  int id;
  @override
  State<CheckPlaylist> createState() => _CheckPlaylistState();
}

class _CheckPlaylistState extends State<CheckPlaylist> {
  @override
  void initState() {
    Dbfunctions.getAllplaylist();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> updatelist = [];
    List<dynamic> songlists = [];
    List<dynamic> afterdeletelist = [];
    final finalplylistIndex = Dbfunctions .playlist.value[widget.folderindex].playlistsongs.indexWhere((element) => element == widget.id);

    final playlistIndex = Dbfunctions .playlist.value[widget.folderindex].playlistsongs .contains(widget.id);
    if (playlistIndex != true) {
      return IconButton(
        onPressed: () async {
          // Dbfunctions.getAllplaylist();
          songlists.add(widget.id);
          updatelist = [
            songlists,
            Dbfunctions.playlist.value[widget.folderindex].playlistsongs
          ].expand((element) => element).toList();
          final updatedetai = PlaylistsModel(
              playlistsongs: updatelist,
              foldername: Dbfunctions.playlist.value[widget.folderindex].foldername);
          await Dbfunctions.updateplaylist(widget.folderindex, updatedetai);
        PlaylistsongsFunctions.showsongs(widget.folderindex);
          setState(() {});
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Center( child: Text('Refresh Your Playlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 224, 238, 231)), )),
          //   margin: EdgeInsets.only( top: 50, bottom: 50, ),
          //   behavior: SnackBarBehavior.floating, backgroundColor: Colors.transparent,duration: Duration(seconds: 1), ));
        },
        icon: const Icon( Icons.add_circle_outline_rounded, color: Colors.green, ),
      );
    }
    return IconButton(
        onPressed: () {
          setState(() {});
          Dbfunctions.playlist.value[widget.folderindex].playlistsongs .removeAt(finalplylistIndex);

          afterdeletelist = [songlists, Dbfunctions.playlist.value[widget.folderindex].playlistsongs ].expand((element) => element).toList();
        final model= PlaylistsModel( foldername: Dbfunctions.playlist.value[widget.folderindex].foldername, playlistsongs: afterdeletelist);
          Dbfunctions.updateplaylist(widget.folderindex, model);
        },
        icon: const Icon( Icons.remove, color: Colors.red, ));
  }
}
