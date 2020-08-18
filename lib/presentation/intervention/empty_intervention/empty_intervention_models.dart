import 'package:domain/model/intervention.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';

class EmptyInterventionSuccess extends Success {
  EmptyInterventionSuccess({
    intervention,
    nextInterventionType,
    nextPage,
  }) : super(
      intervention: intervention,
      nextInterventionType: nextInterventionType,
      nextPage: nextPage);
}
