import 'package:meta/meta.dart';

import '../data_repository/programs_data_repository.dart';
import '../model/program.dart';
import 'use_case.dart';

class GetProgramsListUC extends UseCase<void, List<Program>> {
  GetProgramsListUC({
    @required this.programsRepository,
  }) : assert(programsRepository != null);

  final ProgramDataRepository programsRepository;

  @override
  Future<List<Program>> getRawFuture({void params}) =>
      programsRepository.getProgramList();
}