import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'observer_cm.g.dart';

@HiveType(typeId: 5)
class ObserverCM {
  ObserverCM({
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
  final String role;

  @HiveField(6)
  final List<int> observerContacts;
}
