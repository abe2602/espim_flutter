import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'complex_condition_cm.g.dart';

@HiveType(typeId: 0)
class ComplexConditionCM {
  ComplexConditionCM({
    @required this.dependencyCondition,
    @required this.complexAction,
  })  : assert(dependencyCondition != null),
        assert(complexAction != null);

  @HiveField(0)
  final int dependencyCondition;

  @HiveField(1)
  final String complexAction;
}
