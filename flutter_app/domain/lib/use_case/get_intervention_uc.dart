import 'package:domain/model/event.dart';
import 'package:domain/model/intervention.dart';
import 'package:flutter/foundation.dart';

import '../data_repository/programs_data_repository.dart';
import 'use_case.dart';

class GetInterventionUC extends UseCase<GetInterventionUCParams, Intervention> {
  GetInterventionUC({
    @required this.programsRepository,
  }) : assert(programsRepository != null);

  final ProgramDataRepository programsRepository;

  @override
  Future<Intervention> getRawFuture({GetInterventionUCParams params}) =>
      programsRepository.getIntervention(params.eventId, params.pageNumber);
}

class GetInterventionUCParams {
  const GetInterventionUCParams(
      {@required this.eventId, @required this.pageNumber})
      : assert(eventId != null),
        assert(pageNumber != null);

  final int eventId;
  final int pageNumber;
}
