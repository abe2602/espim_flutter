import 'package:domain/model/question_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/validate_empty_field_uc.dart';
import 'package:domain/model/event_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/closed_question_intervention/closed_question_intervention_bloc.dart';

import 'package:provider/provider.dart';
import 'package:domain/model/intervention_result.dart';

import '../../intervention_models.dart';
import 'closed_question_intervention_models.dart';

class ClosedQuestionInterventionPage extends StatelessWidget {
  const ClosedQuestionInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EventResult eventResult;
  final ClosedQuestionInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider<GetInterventionUC, ClosedQuestionInterventionBloc>(
        update: (context, getInterventionUC, _) =>
            ClosedQuestionInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<ClosedQuestionInterventionBloc>(
          builder: (context, bloc, _) => ClosedQuestionInterventionPage(
            eventId: eventId,
            flowSize: flowSize,
            eventResult: eventResult,
            bloc: bloc,
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
          child: StreamBuilder(
            stream: bloc.onNewState,
            builder: (context, snapshot) =>
                AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              successWidgetBuilder: (successState) => SensemActionListener(
                actionStream: bloc.navigateToNextIntervention,
                onReceived: (event) {
                  eventResult.interventionResultsList.add(
                    InterventionResult(
                      interventionType: successState.intervention.type,
                      startTime: _startTime,
                      endTime: DateTime.now().millisecondsSinceEpoch,
                      interventionId: successState.intervention.interventionId,
                      answer: 'Mandar o valor aqui',
                    ),
                  );

                  eventResult.interventionsIds
                      .add(successState.intervention.interventionId);

                  navigateToNextIntervention(context, event.item2, flowSize,
                      eventId, event.item1, eventResult);
                },
                child: ClosedQuestionComponent(
                  bloc: bloc,
                  eventId: eventId,
                  flowSize: flowSize,
                  successState: successState,
                ),
              ),
              errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
            ),
          ),
        ),
      ),
    );
  }
}

class ClosedQuestionComponent extends StatefulWidget {
  const ClosedQuestionComponent({
    @required this.bloc,
    @required this.successState,
    @required this.flowSize,
    @required this.eventId,
  })  : assert(bloc != null),
        assert(successState != null);

  final ClosedQuestionInterventionBloc bloc;
  final ClosedQuestionSuccess successState;
  final int flowSize;
  final int eventId;

  @override
  State<StatefulWidget> createState() => ClosedQuestionComponentState();
}

class ClosedQuestionComponentState extends State<ClosedQuestionComponent> {
  int selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = -1;
  }

  @override
  Widget build(BuildContext context) {
    final QuestionIntervention questionIntervention =
        widget.successState.intervention;

    return InterventionBody(
      statement: widget.successState.intervention.statement,
      mediaInformation: widget.successState.intervention.mediaInformation,
      nextPage: widget.successState.nextPage,
      next: widget.successState.intervention.next,
      nextInterventionType: widget.successState.nextInterventionType,
      eventId: widget.eventId,
      flowSize: widget.flowSize,
      orderPosition: widget.successState.intervention.orderPosition,
      onPressed: selectedOption == -1
          ? null
          : () {
              if (widget.flowSize == widget.successState.nextPage) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                widget.bloc.navigateToNextInterventionSink.add(
                    questionIntervention.questionConditions[
                        questionIntervention.questionAnswers[selectedOption]]);
              }
            },
      child: Column(
        children: [
          ...questionIntervention.questionAnswers
              .asMap()
              .map(
                (index, _) => MapEntry(
                  index,
                  Card(
                    color: SenSemColors.lightGray,
                    margin:
                        const EdgeInsets.only(left: 8, right: 10, bottom: 10),
                    child: Container(
                      height: 60,
                      child: Row(
                        children: [
                          Radio(
                            value: index,
                            groupValue: selectedOption,
                            activeColor: SenSemColors.royalBlue,
                            onChanged: (_) {
                              setState(() {
                                selectedOption = index;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              questionIntervention.questionAnswers[index],
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        ],
      ),
    );
  }
}