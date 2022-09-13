// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';

class CheckPlaylist extends GetView {
  CheckPlaylist(
      {Key? key,
      required this.index,
      required this.folderindex,
      required this.id})
      : super(key: key);
  final dynamic index;
  final int folderindex;
  final int id;
  @override
  final Dbfunctions controller = Get.put(Dbfunctions());
  @override
  Widget build(BuildContext context) {
    List<dynamic> updatelist = [];
    List<dynamic> songlists = [];
    List<dynamic> afterdeletelist = [];
    int finalplylistIndex = controller.playlist[folderindex].playlistsongs
        .indexWhere((element) => element == id);

    RxBool playlistIndex =
        controller.playlist[folderindex].playlistsongs.contains(id).obs;
    if (playlistIndex != true) {
      return IconButton(
        onPressed: () async {
          songlists.add(id);
          updatelist = [
            songlists,
            controller.playlist[folderindex].playlistsongs
          ].expand((element) => element).toList();
          final updatedetai = PlaylistsModel(
              playlistsongs: updatelist,
              foldername: controller.playlist[folderindex].foldername);
          await controller.updateplaylist(folderindex, updatedetai);
        },
        icon: const Icon(
          Icons.add_circle_outline_rounded,
          color: Colors.green,
        ),
      );
    }
    return IconButton(
        onPressed: () {
          controller.playlist[folderindex].playlistsongs
              .removeAt(finalplylistIndex);

          afterdeletelist = [
            songlists,
            controller.playlist[folderindex].playlistsongs
          ].expand((element) => element).toList();
          final model = PlaylistsModel(
              foldername: controller.playlist[folderindex].foldername,
              playlistsongs: afterdeletelist);
          controller.updateplaylist(folderindex, model);
        },
        icon: const Icon(
          Icons.remove,
          color: Colors.red,
        ));
  }
}
