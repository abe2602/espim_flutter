import 'package:domain/model/event.dart';
import 'package:meta/meta.dart';

import '../data_repository/programs_data_repository.dart';
import 'use_case.dart';

class GetActiveEventsListUC extends UseCase<void, List<Event>> {
  GetActiveEventsListUC({
    @required this.programsRepository,
  }) : assert(programsRepository != null);

  final ProgramDataRepository programsRepository;

  @override
  Future<List<Event>> getRawFuture({void params}) =>
      programsRepository.getActiveEventList();
}
