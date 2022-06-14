// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistsModelAdapter extends TypeAdapter<PlaylistsModel> {
  @override
  final int typeId = 1;

  @override
  PlaylistsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistsModel(
      foldername: fields[0] as String?,
      playlistsongs: (fields[1] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.foldername)
      ..writeByte(1)
      ..write(obj.playlistsongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
