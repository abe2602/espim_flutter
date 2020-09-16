import '../../intervention_models.dart';

class MultipleAnswerInterventionSuccess extends Success {
  MultipleAnswerInterventionSuccess({
    intervention,
    nextInterventionType,
    nextPage,
  }) : super(
      intervention: intervention,
      nextInterventionType: nextInterventionType,
      nextPage: nextPage);
}
