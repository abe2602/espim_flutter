import 'package:domain/model/user.dart';
import 'package:domain/model/event.dart';
import 'package:flutter_app/data/remote/model/event_rm.dart';

import 'model/user_rm.dart';

extension EventRMToDM on EventRM {
  Event toDM() =>
      Event(id: id, title: title, description: description, owner: owner);
}

extension EventsListRMToDM on List<EventRM> {
  List<Event> toDM() => map(
        (event) => event.toDM(),
      ).toList();
}

extension UserRMToDM on UserRM {
  User toDM() => User(id: id, name: name);
}
