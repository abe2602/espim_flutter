// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsCMAdapter extends TypeAdapter<SettingsCM> {
  @override
  final int typeId = 10;

  @override
  SettingsCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsCM(
      isLandscape: fields[0] as bool,
      isMobileNetworkEnabled: fields[1] as bool,
      isNotificationOnMediaEnabled: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsCM obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isLandscape)
      ..writeByte(1)
      ..write(obj.isMobileNetworkEnabled)
      ..writeByte(2)
      ..write(obj.isNotificationOnMediaEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
