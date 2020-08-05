import 'package:domain/model/event.dart';
import 'package:domain/model/intervention.dart';
import 'package:domain/model/program.dart';

abstract class ProgramDataRepository {
  Future<List<Program>> getProgramList();
  Future<List<Event>> getActiveEventList();
  Future<Intervention> getIntervention(int eventId, int pageNumber);
}