import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'media_information_cm.g.dart';

@HiveType(typeId: 4)
class MediaInformationCM {
  MediaInformationCM(
      {@required this.id,
      @required this.mediaType,
      @required this.mediaUrl,
      @required this.shouldAutoPlay})
      : assert(id != null),
        assert(mediaUrl != null),
        assert(mediaType != null),
        assert(shouldAutoPlay != null);

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String mediaType;

  @HiveField(2)
  final String mediaUrl;

  @HiveField(3)
  final bool shouldAutoPlay;
}
