import 'package:domain/model/intervention_type.dart';
import 'package:meta/meta.dart';

import 'complex_condition.dart';
import 'media_information.dart';

class Intervention {
  Intervention(
      {@required this.interventionId,
      @required this.type,
      @required this.statement,
      @required this.orderPosition,
      @required this.isFirst,
      @required this.next,
      @required this.isObligatory,
      this.complexConditions,
      this.mediaInformation})
      : assert(interventionId != null),
        assert(type != null),
        assert(statement != null),
        assert(orderPosition != null),
        assert(isFirst != null),
        assert(next != null),
        assert(isObligatory != null);

  final int interventionId;

  final InterventionType type;

  final String statement;

  final int orderPosition;

  final bool isFirst;

  final int next;

  final bool isObligatory;

  final List<MediaInformation> mediaInformation;

  final List<ComplexCondition> complexConditions;
}
