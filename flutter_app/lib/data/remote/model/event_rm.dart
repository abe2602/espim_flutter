import 'package:flutter/widgets.dart';

class EventRM {
  const EventRM(
      {@required this.id,
        @required this.title,
        @required this.description,
        @required this.owner})
      : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(owner != null);

  final int id;
  final String title;
  final String description;
  final String owner;
}
