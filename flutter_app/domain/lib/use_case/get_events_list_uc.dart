import 'package:meta/meta.dart';

import '../data_repository/events_data_repository.dart';
import '../model/event.dart';
import 'use_case.dart';

class GetEventsListUC extends UseCase<void, List<Event>> {
  GetEventsListUC({
    @required this.eventsRepository,
  }) : assert(eventsRepository != null);

  final EventsDataRepository eventsRepository;

  @override
  Future<List<Event>> getRawFuture({void params}) =>
      eventsRepository.getEventsList();
}