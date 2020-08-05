import 'package:domain/data_repository/programs_data_repository.dart';
import 'package:domain/model/event.dart';
import 'package:domain/model/intervention.dart';
import 'package:domain/model/program.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/programs_cds.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/cache/cache_to_domain_mappers.dart';
import 'package:flutter_app/data/remote/data_source/programs_rds.dart';
import 'package:flutter_app/data/remote/remote_to_domain_mappers.dart';
import 'package:flutter_app/data/remote/remote_to_cache_mappers.dart';
import 'package:flutter_app/data/remote/model/event_rm.dart';

// Salvar os eventos na cache usando id
// sempre que eu for para uma nova tela, envio qual é a posição do vetor
// que eu preciso buscar!
class ProgramsRepository implements ProgramDataRepository {
  const ProgramsRepository({
    @required this.programsRDS,
    @required this.userCDS,
    @required this.programsCDS,
  }) : assert(programsRDS != null);

  final ProgramsRDS programsRDS;
  final UserCDS userCDS;
  final ProgramsCDS programsCDS;

  @override
  Future<List<Program>> getProgramList() => userCDS.getEmail().then(
        (email) => programsRDS.getProgramList(email).then(
              (eventsList) => eventsList.toDM(),
            ),
      );

  @override
  Future<List<Event>> getActiveEventList() => userCDS.getEmail().then(
        (email) => programsRDS.getProgramList(email).then(
          (programsList) {
            final auxEvents = <EventRM>[];

            programsList.forEach(
              (program) {
                program.eventList.forEach((event) {
                  event.interventionList.sort(
                    (interventionA, interventionB) => interventionA
                        .orderPosition
                        .compareTo(interventionB.orderPosition),
                  );
                });

                program.eventList.forEach((event) async {
                  await programsCDS.upsertInterventionList(
                    event.id,
                    event.interventionList.toCM(),
                  );
                });

                auxEvents?.addAll(
                  program.eventList
                    ..where((event) => event.type == 'active')
                    ..sort(
                      (eventA, eventB) => eventA.title.compareTo(eventB.title),
                    ),
                );
              },
            );
            return auxEvents.toDM();
          },
        ),
      );

  @override
  Future<Intervention> getIntervention(int eventId, int pageNumber) =>
      programsCDS.getIntervention(eventId, pageNumber).then(
            (intervention) => intervention.toDM(),
          );
}
