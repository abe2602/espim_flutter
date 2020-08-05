// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observer_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ObserverCMAdapter extends TypeAdapter<ObserverCM> {
  @override
  final typeId = 5;

  @override
  ObserverCM read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ObserverCM(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String,
      role: fields[5] as String,
      observerContacts: (fields[6] as List)?.cast<int>(),
      phoneNumber: fields[3] as String,
      profileImageUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ObserverCM obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.observerContacts);
  }
}
