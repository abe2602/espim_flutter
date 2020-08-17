import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/empty_intervention/empty_intervention_bloc.dart';
import 'package:provider/provider.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:video_player/video_player.dart';

import '../intervention_models.dart';
import 'empty_intervention_models.dart';

class EmptyInterventionPage extends StatelessWidget {
  const EmptyInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null);
  final EmptyInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize) =>
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
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              right: 15,
              left: 15,
            ),
            child: StreamBuilder(
              stream: bloc.onNewState,
              builder: (context, snapshot) => AsyncSnapshotResponseView<Loading,
                  Error, EmptyInterventionSuccess>(
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
                    navigateToNextIntervention(
                      context,
                      successState.nextPage,
                      flowSize,
                      eventId,
                      successState.nextInterventionType,
                    );
                  },
                ),
                errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
              ),
            ),
          ),
        ),
      );
}
