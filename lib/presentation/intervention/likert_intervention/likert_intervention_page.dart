import 'package:domain/model/event_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikertInterventionPage extends StatefulWidget {
  const LikertInterventionPage({
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
  })  : assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EventResult eventResult;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      LikertInterventionPage(
        eventId: eventId,
        flowSize: flowSize,
        eventResult: eventResult,
      );

  @override
  State<StatefulWidget> createState() => LikertInterventionPageState();
}

class LikertInterventionPageState extends State<LikertInterventionPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
    body: Text('LIKERTT'),
      );
}
