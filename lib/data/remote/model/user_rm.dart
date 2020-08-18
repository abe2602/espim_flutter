import 'package:flutter/widgets.dart';

class UserRM {
  const UserRM({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  final int id;
  final String name;
}
