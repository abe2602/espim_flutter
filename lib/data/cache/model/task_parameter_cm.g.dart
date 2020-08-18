// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_parameter_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskParameterCMAdapter extends TypeAdapter<TaskParameterCM> {
  @override
  final int typeId = 9;

  @override
  TaskParameterCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskParameterCM(
      videoUrl: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskParameterCM obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.videoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskParameterCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
