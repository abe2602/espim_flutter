import 'package:flutter_app/presentation/intervention/intervention_models.dart';

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
