import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_rm.g.dart';

@JsonSerializable()
class LoginRM {
  const LoginRM(
      {@required this.id})
      : assert(id != null);

  factory LoginRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$LoginRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$LoginRMToJson(this);

  @JsonKey(name: 'id')
  final String id;
}