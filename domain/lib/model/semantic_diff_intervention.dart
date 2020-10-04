import 'package:domain/model/intervention.dart';
import 'package:meta/meta.dart';

class SemanticDiffIntervention extends Intervention {
  SemanticDiffIntervention(
      {@required this.scales,
      interventionId,
      type,
      statement,
      orderPosition,
      isFirst,
      next,
      isObligatory,
      complexConditions,
      mediaInformation})
      : assert(scales != null),
        super(
          interventionId: interventionId,
          type: type,
          statement: statement,
          orderPosition: orderPosition,
          isFirst: isFirst,
          next: next,
          isObligatory: isObligatory,
          complexConditions: complexConditions,
          mediaInformation: mediaInformation,
        );

  final List<String> scales;
}
