import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/task_intervention/task_intervention_bloc.dart';
import 'package:flutter_app/presentation/intervention/task_intervention/task_intervention_models.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../intervention_models.dart';

class TaskInterventionPage extends StatelessWidget {
  const TaskInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null);
  final TaskInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize) =>
      ProxyProvider<GetInterventionUC, TaskInterventionBloc>(
        update: (context, getInterventionUC, _) => TaskInterventionBloc(
          eventId: eventId,
          flowSize: flowSize,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<TaskInterventionBloc>(
          builder: (context, bloc, _) => TaskInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
          ),
        ),
      );

  Future<void> _launchURL(String siteUrl) async {
    if (await canLaunch(siteUrl)) {
      await launch(siteUrl);
    } else {
      throw 'Could not launch $siteUrl';
    }
  }

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
                  Error, TaskInterventionSuccess>(
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
                  child: FlatButton(
                    onPressed: () {
                      _launchURL(successState.taskParameters.videoUrl);
                    },
                    color: SenSemColors.lightRoyalBlue,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        S.of(context).open_outside_link,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
              ),
            ),
          ),
        ),
      );
}
