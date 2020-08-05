// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_parameter_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskParameterCMAdapter extends TypeAdapter<TaskParameterCM> {
  @override
  final typeId = 9;

  @override
  TaskParameterCM read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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
}
