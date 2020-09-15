import 'package:flutter_app/presentation/intervention/intervention_models.dart';

class SemanticDiffSuccess extends Success {
  SemanticDiffSuccess({
    intervention,
    nextInterventionType,
    nextPage,
    this.semanticDiffSize,
    this.semanticDiffLabels,
    this.semanticDiffScale,
  }) : super(
            intervention: intervention,
            nextInterventionType: nextInterventionType,
            nextPage: nextPage);
  final int semanticDiffSize;
  final List<String> semanticDiffScale;
  final List<String> semanticDiffLabels;
}
