// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgramCMAdapter extends TypeAdapter<ProgramCM> {
  @override
  final int typeId = 7;

  @override
  ProgramCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramCM(
      title: fields[0] as String,
      description: fields[1] as String,
      startTime: fields[2] as String,
      endTime: fields[3] as String,
      updateTime: fields[4] as String,
      hasPhase: fields[5] as bool,
      isPublic: fields[6] as bool,
      eventList: (fields[9] as List)?.cast<EventCM>(),
      observer: (fields[8] as List)?.cast<ObserverCM>(),
      participants: (fields[7] as List)?.cast<ParticipantCM>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProgramCM obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.updateTime)
      ..writeByte(5)
      ..write(obj.hasPhase)
      ..writeByte(6)
      ..write(obj.isPublic)
      ..writeByte(7)
      ..write(obj.participants)
      ..writeByte(8)
      ..write(obj.observer)
      ..writeByte(9)
      ..write(obj.eventList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
