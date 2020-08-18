// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParticipantCMAdapter extends TypeAdapter<ParticipantCM> {
  @override
  final int typeId = 6;

  @override
  ParticipantCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParticipantCM(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String,
      nickName: fields[5] as String,
      phoneNumber: fields[3] as String,
      profileImageUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ParticipantCM obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.profileImageUrl)
      ..writeByte(5)
      ..write(obj.nickName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
