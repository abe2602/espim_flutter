import 'package:flutter/foundation.dart';

class MediaInformation {
  MediaInformation(
      {@required this.id,
      @required this.mediaType,
      @required this.mediaUrl,
      @required this.shouldAutoPlay})
      : assert(id != null),
        assert(mediaUrl != null),
        assert(mediaType != null),
        assert(shouldAutoPlay != null);

  final int id;

  final String mediaType;

  final String mediaUrl;

  final bool shouldAutoPlay;
}
