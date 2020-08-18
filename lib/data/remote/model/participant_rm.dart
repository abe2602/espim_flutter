import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant_rm.g.dart';

@JsonSerializable()
class ParticipantRM {
  ParticipantRM({
    @required this.id,
    @required this.name,
    @required this.email,
    this.nickName,
    this.phoneNumber,
    this.profileImageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null);

  factory ParticipantRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$ParticipantRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$ParticipantRMToJson(this);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;

  @JsonKey(name: 'profilePhotoUrl')
  final String profileImageUrl;

  @JsonKey(name: 'alias')
  final String nickName;
}
