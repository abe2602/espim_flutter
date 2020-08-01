import 'package:domain/model/program.dart';

abstract class ProgramDataRepository {
  Future<List<Program>> getProgramList();
}