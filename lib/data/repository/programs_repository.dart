import 'package:dio/dio.dart';
import 'package:domain/data_repository/programs_data_repository.dart';
import 'package:domain/model/event.dart';
import 'package:domain/model/intervention.dart';
import 'package:domain/model/program.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/cache_to_domain_mappers.dart';
import 'package:flutter_app/data/cache/programs_cds.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/remote/data_source/auh_rds.dart';
import 'package:flutter_app/data/remote/data_source/programs_rds.dart';
import 'package:flutter_app/data/remote/model/event_rm.dart';
import 'package:flutter_app/data/remote/remote_to_cache_mappers.dart';
import 'package:flutter_app/data/remote/remote_to_domain_mappers.dart';

// Salvar os eventos na cache usando id
// sempre que eu for para uma nova tela, envio qual é a posição do vetor
// que eu preciso buscar!
class ProgramsRepository implements ProgramDataRepository {
  const ProgramsRepository({
    @required this.programsRDS,
    @required this.userCDS,
    @required this.programsCDS,
    @required this.authRDS,
  }) : assert(programsRDS != null);

  final ProgramsRDS programsRDS;
  final UserCDS userCDS;
  final ProgramsCDS programsCDS;
  final AuthRDS authRDS;

  @override
  Future<List<Program>> getProgramList() => userCDS.getEmail().then(
        (email) => programsRDS.getProgramList(email).then(
              (eventsList) => eventsList.toDM(),
            ),
      );

  @override
  Future<List<Event>> getActiveEventList() => userCDS
      .getEmail()
      .then(
        (email) => programsRDS.getProgramList('kamila.uniara@gmail.com').then(
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

                auxEvents?.addAll(
                  program.eventList
                    ..where((event) => event.type == 'active')
                    ..sort(
                      (eventA, eventB) => eventA.title.compareTo(eventB.title),
                    ),
                );
              },
            );
            return auxEvents;
          },
        ).then((eventList) {
          programsCDS.upsertEventsList(eventList.toCM());
          return eventList.toDM();
        }),
      )
      .catchError(
        (error) {
          if(error is DioError && error.response.statusCode == 401) {
            return authRDS.signInWithGoogle().then(
                  (_) => getActiveEventList(),
            );
          } else {
            throw error;
          }
        }
      );

  @override
  Future<Intervention> getIntervention(int eventId, int positionOrder) =>
      programsCDS.getInterventionByPositionOrder(eventId, positionOrder).then(
            (intervention) => intervention.toDM(),
          );
}
