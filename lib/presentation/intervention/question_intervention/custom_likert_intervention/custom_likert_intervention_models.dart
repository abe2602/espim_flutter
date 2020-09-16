import 'package:flutter_app/presentation/intervention/intervention_models.dart';

class CustomLikertSuccess extends Success {
  CustomLikertSuccess({
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

