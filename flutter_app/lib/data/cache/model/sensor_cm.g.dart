// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensorCMAdapter extends TypeAdapter<SensorCM> {
  @override
  final int typeId = 8;

  @override
  SensorCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensorCM();
  }

  @override
  void write(BinaryWriter writer, SensorCM obj) {
    writer..writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
