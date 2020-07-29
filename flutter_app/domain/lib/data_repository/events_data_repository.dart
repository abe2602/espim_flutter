import 'package:domain/model/event.dart';

abstract class EventsDataRepository {
  Future<List<Event>> getEventsList();
}