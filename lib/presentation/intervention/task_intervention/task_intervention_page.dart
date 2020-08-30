import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/model/event_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/task_intervention/task_intervention_bloc.dart';
import 'package:flutter_app/presentation/intervention/task_intervention/task_intervention_models.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:domain/model/intervention_result.dart';

import '../intervention_models.dart';

class TaskInterventionPage extends StatefulWidget {
  const TaskInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EventResult eventResult;
  final TaskInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
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
            eventResult: eventResult,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => TaskInterventionPageState();
}

class TaskInterventionPageState extends State<TaskInterventionPage> {
  bool _isTaskDone = false;
  final _startTime = DateTime.now().millisecondsSinceEpoch;

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
              stream: widget.bloc.onNewState,
              builder: (context, snapshot) => AsyncSnapshotResponseView<Loading,
                  Error, TaskInterventionSuccess>(
                snapshot: snapshot,
                successWidgetBuilder: (successState) => InterventionBody(
                  statement: successState.intervention.statement,
                  mediaInformation: successState.intervention.mediaInformation,
                  nextPage: successState.nextPage,
                  next: successState.intervention.next,
                  nextInterventionType: successState.nextInterventionType,
                  eventId: widget.eventId,
                  flowSize: widget.flowSize,
                  orderPosition: successState.intervention.orderPosition,
                  onPressed: !_isTaskDone
                      ? null
                      : () {
                          widget.eventResult.interventionResultsList.add(
                            InterventionResult(
                              interventionType: successState.intervention.type,
                              startTime: _startTime,
                              endTime: DateTime.now()
                                  .millisecondsSinceEpoch,
                              interventionId:
                                  successState.intervention.interventionId,
                            ),
                          );

                          widget.eventResult.interventionsIds
                              .add(successState.intervention.interventionId);

                          navigateToNextIntervention(
                            context,
                            successState.nextPage,
                            widget.flowSize,
                            widget.eventId,
                            successState.nextInterventionType,
                            widget.eventResult,
                          );
                        },
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _isTaskDone = true;
                      });

                      _launchURL(
                        successState.taskParameters[
                            successState.taskParameters.keys.toList()[0]],
                      );
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
