import 'intervention.dart';

class EmptyIntervention extends Intervention {
  EmptyIntervention(
      {type,
      statement,
      orderPosition,
      isFirst,
      next,
      isObligatory,
      complexConditions,
      mediaInformation})
      : super(
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
