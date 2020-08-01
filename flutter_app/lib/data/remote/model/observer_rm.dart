import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'observer_rm.g.dart';

@JsonSerializable()
class ObserverRM {
  ObserverRM({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.role,
    @required this.observerContacts,
    this.phoneNumber,
    this.profileImageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null),
        assert(role != null),
        assert(observerContacts != null);

  factory ObserverRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$ObserverRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$ObserverRMToJson(this);

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

  @JsonKey(name: 'role')
  final String role;

  @JsonKey(name: 'contacts')
  final List<int> observerContacts;
}
