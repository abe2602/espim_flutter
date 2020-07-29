import 'package:domain/data_repository/events_data_repository.dart';
import 'package:domain/model/event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/remote/data_source/events_rds.dart';
import 'package:flutter_app/data/remote/mappers.dart';

class EventsRepository implements EventsDataRepository {
  const EventsRepository({
    @required this.eventsRDS,
    @required this.userCDS,
  }) : assert(eventsRDS != null);

  final EventsRDS eventsRDS;
  final UserCDS userCDS;

  @override
  Future<List<Event>> getEventsList() => userCDS
      .getEmail()
      .then(
        (email) => eventsRDS.getEventsList(email).then(
              (eventsList) => eventsList.toDM(),
            ),
      );
}
