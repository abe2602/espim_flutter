import 'package:flutter/foundation.dart';

class TaskParameter {
  const TaskParameter({
    @required this.videoUrl,
  })  : assert(videoUrl != null);

  final String videoUrl;
}