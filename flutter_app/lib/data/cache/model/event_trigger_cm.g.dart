// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_trigger_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventTriggerCMAdapter extends TypeAdapter<EventTriggerCM> {
  @override
  final int typeId = 2;

  @override
  EventTriggerCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventTriggerCM(
      id: fields[0] as int,
      triggerType: fields[1] as String,
      triggerCondition: fields[2] as String,
      priority: fields[3] as String,
      timeOut: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EventTriggerCM obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.triggerType)
      ..writeByte(2)
      ..write(obj.triggerCondition)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.timeOut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTriggerCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
