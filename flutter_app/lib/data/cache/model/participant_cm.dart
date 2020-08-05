import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'participant_cm.g.dart';

@HiveType(typeId: 6)
class ParticipantCM {
  ParticipantCM({
    @required this.id,
    @required this.name,
    @required this.email,
    this.nickName,
    this.phoneNumber,
    this.profileImageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null);

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String profileImageUrl;

  @HiveField(5)
  final String nickName;
}
