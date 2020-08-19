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
      programsRepository
          .getIntervention(
              params.eventId, params.positionOrder);
}

class GetInterventionUCParams {
  const GetInterventionUCParams(
      {@required this.eventId, this.positionOrder})
      : assert(eventId != null);

  final int eventId;
  final int positionOrder;
}
