// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventCMAdapter extends TypeAdapter<EventCM> {
  @override
  final int typeId = 1;

  @override
  EventCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventCM(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as String,
      eventTriggerList: (fields[4] as List)?.cast<EventTriggerCM>(),
      interventionList: (fields[5] as List)?.cast<InterventionCM>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventCM obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.eventTriggerList)
      ..writeByte(5)
      ..write(obj.interventionList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
