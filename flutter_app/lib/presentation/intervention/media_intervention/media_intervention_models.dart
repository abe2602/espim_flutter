import 'package:flutter/widgets.dart';

import '../intervention_models.dart';

class MediaInterventionSuccess extends Success {
  MediaInterventionSuccess({
    @required this.mediaType,
    intervention,
    nextInterventionType,
    nextPage,
  }) : super(
      intervention: intervention,
      nextInterventionType: nextInterventionType,
      nextPage: nextPage);

  final String mediaType;
}