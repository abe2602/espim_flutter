// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_information_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaInformationCMAdapter extends TypeAdapter<MediaInformationCM> {
  @override
  final typeId = 4;

  @override
  MediaInformationCM read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaInformationCM(
      id: fields[0] as int,
      mediaType: fields[1] as String,
      mediaUrl: fields[2] as String,
      shouldAutoPlay: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MediaInformationCM obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mediaType)
      ..writeByte(2)
      ..write(obj.mediaUrl)
      ..writeByte(3)
      ..write(obj.shouldAutoPlay);
  }
}
