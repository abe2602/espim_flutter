// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complex_condition_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComplexConditionCMAdapter extends TypeAdapter<ComplexConditionCM> {
  @override
  final int typeId = 0;

  @override
  ComplexConditionCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplexConditionCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
