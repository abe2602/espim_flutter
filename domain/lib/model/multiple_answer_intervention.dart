import 'package:domain/model/intervention.dart';
import 'package:meta/meta.dart';

class MultipleAnswerIntervention extends Intervention {
  MultipleAnswerIntervention(
      {@required this.questionType,
      this.questionConditions,
      this.questionAnswers,
      this.scales,
      interventionId,
      type,
      statement,
      orderPosition,
      isFirst,
      next,
      isObligatory,
      complexConditions,
      mediaInformation})
      : assert(questionType != null),
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

  final int questionType;
  final List<String> questionAnswers;
  final Map<String, int> questionConditions;
  final List<String> scales;
}
