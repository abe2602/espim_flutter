import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'task_parameter_cm.g.dart';

@HiveType(typeId: 9)
class TaskParameterCM {
  const TaskParameterCM({
    @required this.videoUrl,
  }) : assert(videoUrl != null);

  @HiveField(0)
  final String videoUrl;
}
