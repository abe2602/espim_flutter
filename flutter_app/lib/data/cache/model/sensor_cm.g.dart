// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensorCMAdapter extends TypeAdapter<SensorCM> {
  @override
  final typeId = 8;

  @override
  SensorCM read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensorCM();
  }

  @override
  void write(BinaryWriter writer, SensorCM obj) {
    writer..writeByte(0);
  }
}
