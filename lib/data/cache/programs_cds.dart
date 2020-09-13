import 'package:flutter_app/data/cache/model/event_cm.dart';
import 'package:flutter_app/data/cache/model/intervention_cm.dart';
import 'package:hive/hive.dart';

class ProgramsCDS {
  static const _eventsListBoxKey = 'eventsListBoxKey';

  Future<Box> _openInterventionLisBox() => Hive.openBox(_eventsListBoxKey);

  /*
  * Programas -> Eventos -> Intervenções; Aqui eu só devo
  * mostrar OS EVENTOS ATIVOS.
  * */
  Future<void> upsertEventsList(List<EventCM> eventList) =>
      _openInterventionLisBox()
          .then((box) => box.clear().then((_) => box.add(eventList)));

  Future<InterventionCM> getInterventionByPositionOrder(
          int eventId, int position) =>
      _openInterventionLisBox().then(
        (box) {
          final List<EventCM> eventsList = box.get(0);

          final myEvent =
              eventsList.where((event) => event.id == eventId).toList()[0];

          return myEvent.interventionList
              .where((intervention) => intervention.orderPosition == position)
              .toList()[0];
        },
      );
}
