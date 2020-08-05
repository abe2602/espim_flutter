import 'package:flutter_app/data/cache/model/intervention_cm.dart';
import 'package:hive/hive.dart';

class ProgramsCDS {
  static const _interventionListBoxKey = 'interventionBoxKey';
  static const _eventsListBoxKey = 'interventionBoxKey';
  static const _programListBoxKey = 'programListBoxKey';

  Future<Box> _openInterventionLisBox() =>
      Hive.openBox(_interventionListBoxKey);

  Future<Box> _openProgramLisBox() => Hive.openBox(_programListBoxKey);

  /*
  * Programas -> Eventos -> Intervenções; Aqui eu só devo mostrar OS EVENTOS ATIVOS.
  * */
  Future<void> upsertInterventionList(
          int eventId, List<InterventionCM> interventionList) =>
      _openInterventionLisBox().then(
        (box) => box.put(eventId, interventionList),
      ).catchError((error){
        print('erro ao colocar ' + error.toString());
      });

  Future<InterventionCM> getIntervention(int eventId, int pageNumber) =>
      _openInterventionLisBox().then(
        (box) {
          final List<InterventionCM> interventionList = box.get(eventId);
          return interventionList[pageNumber];
        },
      ).catchError((error) {
        print('erro ao tirar ' + error.toString());
      });
}
