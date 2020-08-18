import 'package:flutter/foundation.dart';

class Observer {
  Observer({
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


  final int id;

  final String name;

  final String email;

  final String phoneNumber;

  final String profileImageUrl;

  final String role;

  final List<int> observerContacts;
}