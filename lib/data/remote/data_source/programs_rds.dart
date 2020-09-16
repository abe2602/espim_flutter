import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/remote/model/program_rm.dart';

class ProgramsRDS {
  const ProgramsRDS({
    @required this.dio,
  }) : assert(dio != null);

  final Dio dio;

  Future<List<ProgramRM>> getProgramList(String email) =>
      dio.get('programs/search/findByParticipantsEmail/?email=$email').then(
            (programs) => List<ProgramRM>.from(
              programs.data.map(
                (program) => ProgramRM.fromJson(program),
              ),
            )
//                .where((program) =>
//                    DateTime.now().millisecondsSinceEpoch >=
//                        int.parse(program.startTime) &&
//                    DateTime.now().millisecondsSinceEpoch <=
//                        int.parse(program.endTime))
                .toList(),
          );
}
