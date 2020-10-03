import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/intervention_body.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/empty_intervention/empty_intervention_bloc.dart';
import 'package:provider/provider.dart';

import '../intervention_models.dart';
import 'empty_intervention_models.dart';

class EmptyInterventionPage extends StatelessWidget {
  const EmptyInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EmptyInterventionBloc bloc;
  final int eventId;
  final int flowSize;
  final EventResult eventResult;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider<GetInterventionUC, EmptyInterventionBloc>(
        update: (context, getInterventionUC, _) => EmptyInterventionBloc(
          eventId: eventId,
          flowSize: flowSize,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<EmptyInterventionBloc>(
          builder: (context, bloc, _) => EmptyInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
            eventResult: eventResult,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final _startTime = DateTime.now().millisecondsSinceEpoch;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acompanhamentos'),
        backgroundColor: const Color(0xff125193),
      ),
      body: StreamBuilder(
        stream: bloc.onNewState,
        builder: (context, snapshot) =>
            AsyncSnapshotResponseView<Loading, Error, EmptyInterventionSuccess>(
          snapshot: snapshot,
          successWidgetBuilder: (successState) => InterventionBody(
            statement: successState.intervention.statement,
            mediaInformation: successState.intervention.mediaInformation,
            nextPage: successState.nextPage,
            next: successState.intervention.next,
            nextInterventionType: successState.nextInterventionType,
            eventId: eventId,
            flowSize: flowSize,
            orderPosition: successState.intervention.orderPosition,
            onPressed: () {
              eventResult.interventionResultsList.add(
                InterventionResult(
                  interventionType: successState.intervention.type,
                  startTime: _startTime,
                  endTime: DateTime.now().millisecondsSinceEpoch,
                  interventionId: successState.intervention.interventionId,
                ),
              );

              eventResult.interventionsIds
                  .add(successState.intervention.interventionId);

              navigateToNextIntervention(
                context,
                successState.nextPage,
                flowSize,
                eventId,
                successState.nextInterventionType,
                EventResult(
                  startTime: eventResult.startTime,
                  eventId: eventResult.eventId,
                  interventionResultsList: eventResult.interventionResultsList,
                  interventionsIds: eventResult.interventionsIds,
                  eventTrigger: eventResult.eventTrigger,
                ),
              );
            },
          ),
          errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
        ),
      ),
    );
  }
}
