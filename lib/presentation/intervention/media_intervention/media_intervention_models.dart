import '../intervention_models.dart';

class MediaInterventionSuccess extends Success {
  MediaInterventionSuccess({
    intervention,
    nextInterventionType,
    nextPage,
  }) : super(
            intervention: intervention,
            nextInterventionType: nextInterventionType,
            nextPage: nextPage);
}
