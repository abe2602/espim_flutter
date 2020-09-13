import 'package:flutter_app/presentation/intervention/intervention_models.dart';

class SemanticDiffSuccess extends Success {
  SemanticDiffSuccess({
    intervention,
    nextInterventionType,
    nextPage,
    this.likertScales,
  }) : super(
      intervention: intervention,
      nextInterventionType: nextInterventionType,
      nextPage: nextPage);

  final List<String> likertScales;
}
