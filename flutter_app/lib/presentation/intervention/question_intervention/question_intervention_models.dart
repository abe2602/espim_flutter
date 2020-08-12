import 'package:flutter_app/presentation/intervention/intervention_models.dart';

class ClosedQuestionSuccess extends Success {
  ClosedQuestionSuccess({
    intervention,
    nextInterventionType,
    nextPage,
  }) : super(
      intervention: intervention,
      nextInterventionType: nextInterventionType,
      nextPage: nextPage);
}

class OpenQuestionSuccess extends Success {
  OpenQuestionSuccess({
    intervention,
    nextInterventionType,
    nextPage,
  }) : super(
            intervention: intervention,
            nextInterventionType: nextInterventionType,
            nextPage: nextPage);
}
