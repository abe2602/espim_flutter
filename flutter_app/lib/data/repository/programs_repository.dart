import 'package:domain/data_repository/programs_data_repository.dart';
import 'package:domain/model/event.dart';
import 'package:domain/model/program.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/remote/data_source/events_rds.dart';
import 'package:flutter_app/data/remote/mappers.dart';

class ProgramsRepository implements ProgramDataRepository {
  const ProgramsRepository({
    @required this.eventsRDS,
    @required this.userCDS,
  }) : assert(eventsRDS != null);

  final ProgramsRDS eventsRDS;
  final UserCDS userCDS;

  @override
  Future<List<Program>> getProgramList() => userCDS
      .getEmail()
      .then(
        (email) => eventsRDS.getEventsList('kamila.uniara@gmail.com').then(
              (eventsList) => eventsList.toDM(),
            ),
      ).catchError((error) {
        print('ERROUUU' + error.toString());
        throw error;
  });
}
