import 'package:flutter_app/presentation/intervention/intervention_models.dart';

class LikertSuccess extends Success {
  LikertSuccess({
    intervention,
    nextInterventionType,
    nextPage,
    this.optionsList,
    this.likertScales,
    this.likertType,
  }) : super(
      intervention: intervention,
      nextInterventionType: nextInterventionType,
      nextPage: nextPage);

  final List<String> optionsList;
  final List<String> likertScales;
  final LikertType likertType;
}

enum LikertType {agreement, frequency, satisfaction}