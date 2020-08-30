import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/model/complex_condition_cm.dart';
import 'package:flutter_app/data/cache/model/media_information_cm.dart';
import 'package:hive/hive.dart';

part 'intervention_cm.g.dart';

@HiveType(typeId: 3)
class InterventionCM {
  InterventionCM(
      {@required this.interventionId,
        @required this.type,
      @required this.statement,
      @required this.orderPosition,
      @required this.isFirst,
      @required this.next,
      @required this.isObligatory,
      this.complexConditions,
      this.questionType,
      this.questionAnswers,
      this.questionConditions,
      this.scales,
      this.appPackage,
      this.taskParameters,
      this.startFromNotification,
      this.mediaType,
      this.mediaInformation})
      : assert(interventionId != null),
        assert(type != null),
        assert(statement != null),
        assert(orderPosition != null),
        assert(isFirst != null),
        assert(next != null),
        assert(isObligatory != null);

  @HiveField(0)
  final String type;

  @HiveField(1)
  final String statement;

  @HiveField(2)
  final int orderPosition;

  @HiveField(3)
  final bool isFirst;

  @HiveField(4)
  final int next;

  @HiveField(5)
  final bool isObligatory;

  @HiveField(6)
  final List<MediaInformationCM> mediaInformation;

  @HiveField(7)
  final List<ComplexConditionCM> complexConditions;

  @HiveField(8)
  final int questionType;

  @HiveField(9)
  final List<String> questionAnswers;

  @HiveField(10)
  final Map<String, int> questionConditions;

  @HiveField(11)
  final List<String> scales;

  @HiveField(12)
  final String appPackage;

  @HiveField(13)
  final Map<String, String> taskParameters;

  @HiveField(14)
  final bool startFromNotification;

  @HiveField(15)
  final String mediaType;

  @HiveField(16)
  final int interventionId;
}
