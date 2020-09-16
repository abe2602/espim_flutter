import 'intervention.dart';

class EmptyIntervention extends Intervention {
  EmptyIntervention(
      {interventionId,
      type,
      statement,
      orderPosition,
      isFirst,
      next,
      isObligatory,
      complexConditions,
      mediaInformation})
      : super(
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
}
