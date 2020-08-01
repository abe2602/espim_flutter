import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_parameter_rm.g.dart';

@JsonSerializable()
class TaskParameterRM {
  const TaskParameterRM({
    @required this.videoUrl,
  })  : assert(videoUrl != null);

  factory TaskParameterRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$TaskParameterRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$TaskParameterRMToJson(this);

  @JsonKey(name: 'youtube')
  final String videoUrl;
}