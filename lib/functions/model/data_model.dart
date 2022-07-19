import 'package:hive_flutter/adapters.dart';
part 'data_model.g.dart';
@HiveType(typeId: 1)
class PlaylistsModel {
@HiveField(0)
String? foldername;
@HiveField(1)
List<dynamic>playlistsongs;
PlaylistsModel({  this.foldername,  this.playlistsongs =const []});

  whenComplete(allplaylist) {}

  then(allplaylist) {}
}