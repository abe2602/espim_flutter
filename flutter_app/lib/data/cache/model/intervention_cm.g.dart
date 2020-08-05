// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterventionCMAdapter extends TypeAdapter<InterventionCM> {
  @override
  final typeId = 3;

  @override
  InterventionCM read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InterventionCM(
      type: fields[0] as String,
      statement: fields[1] as String,
      orderPosition: fields[2] as int,
      isFirst: fields[3] as bool,
      next: fields[4] as int,
      isObligatory: fields[5] as bool,
      complexConditions: (fields[7] as List)?.cast<ComplexConditionCM>(),
      questionType: fields[8] as int,
      questionAnswers: (fields[9] as List)?.cast<String>(),
      questionConditions: (fields[10] as Map)?.cast<String, int>(),
      scales: (fields[11] as List)?.cast<String>(),
      appPackage: fields[12] as String,
      taskParameters: fields[13] as TaskParameterCM,
      startFromNotification: fields[14] as bool,
      mediaType: fields[15] as String,
      mediaInformation: (fields[6] as List)?.cast<MediaInformationCM>(),
    );
  }

  @override
  void write(BinaryWriter writer, InterventionCM obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.statement)
      ..writeByte(2)
      ..write(obj.orderPosition)
      ..writeByte(3)
      ..write(obj.isFirst)
      ..writeByte(4)
      ..write(obj.next)
      ..writeByte(5)
      ..write(obj.isObligatory)
      ..writeByte(6)
      ..write(obj.mediaInformation)
      ..writeByte(7)
      ..write(obj.complexConditions)
      ..writeByte(8)
      ..write(obj.questionType)
      ..writeByte(9)
      ..write(obj.questionAnswers)
      ..writeByte(10)
      ..write(obj.questionConditions)
      ..writeByte(11)
      ..write(obj.scales)
      ..writeByte(12)
      ..write(obj.appPackage)
      ..writeByte(13)
      ..write(obj.taskParameters)
      ..writeByte(14)
      ..write(obj.startFromNotification)
      ..writeByte(15)
      ..write(obj.mediaType);
  }
}
