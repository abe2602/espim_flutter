import 'package:flutter/foundation.dart';

import 'intervention.dart';

class MediaIntervention extends Intervention {
  MediaIntervention(
      {@required this.mediaType,
      interventionId,
      type,
      statement,
      orderPosition,
      isFirst,
      next,
      isObligatory,
      complexConditions,
      mediaInformation})
      : assert(mediaType != null),
        super(
          interventionId: interventionId,
          type: type,
          statement: statement,
          orderPosition: orderPosition,
          isFirst: isFirst,
          next: next,
          isObligatory: isObligatory,
          complexConditions: complexConditions,
          mediaInformation: mediaInformation,
        );

  final String mediaType;
}
