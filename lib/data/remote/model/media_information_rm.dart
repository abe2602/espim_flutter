import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_information_rm.g.dart';

@JsonSerializable()
class MediaInformationRM {
  MediaInformationRM({
    @required this.id,
    @required this.mediaType,
    @required this.mediaUrl,
    @required this.shouldAutoPlay,
  })  : assert(id != null),
        assert(mediaUrl != null),
        assert(mediaType != null),
        assert(shouldAutoPlay != null);

  factory MediaInformationRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$MediaInformationRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$MediaInformationRMToJson(this);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'type')
  final String mediaType;

  @JsonKey(name: 'mediaUrl')
  final String mediaUrl;

  @JsonKey(name: 'autoPlay')
  final bool shouldAutoPlay;
}
