import 'package:flutter/foundation.dart';

class ComplexCondition {
  ComplexCondition({
    @required this.dependencyCondition,
    @required this.complexAction,
  })  : assert(dependencyCondition != null),
        assert(complexAction != null);

  final int dependencyCondition;

  final String complexAction;
}
