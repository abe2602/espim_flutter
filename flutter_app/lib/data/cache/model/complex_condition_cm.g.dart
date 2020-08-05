// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complex_condition_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComplexConditionCMAdapter extends TypeAdapter<ComplexConditionCM> {
  @override
  final typeId = 0;

  @override
  ComplexConditionCM read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComplexConditionCM(
      dependencyCondition: fields[0] as int,
      complexAction: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ComplexConditionCM obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dependencyCondition)
      ..writeByte(1)
      ..write(obj.complexAction);
  }
}
