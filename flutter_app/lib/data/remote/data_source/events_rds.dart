import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/remote/model/character_rm.dart';
import 'package:flutter_app/data/remote/model/event_rm.dart';

class EventsRDS {
  const EventsRDS({
    @required this.dio,
  }) : assert(dio != null);

  final Dio dio;

  //todo: salvar o email na cache e recuperar no Repository, passando por parametro
  // verificar o que é esse "programs"
  Future<List<EventRM>> getEventsList(String email) {
    dio.get('programs/search/findByParticipantsEmail/?email=$email').then(
          (value) => print(
            value.toString(),
          ),
        );

    return Future.value(
      List.generate(
        10,
        (index) => EventRM(
            id: index,
            title: 'Title ' + index.toString(),
            description: 'Description ' + index.toString(),
            owner: 'Abe'),
      ),
    );
  }
}
