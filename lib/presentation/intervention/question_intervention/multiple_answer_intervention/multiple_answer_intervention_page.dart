import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/model/intervention_type.dart';
import 'package:domain/model/multiple_answer_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/intervention_body.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:provider/provider.dart';

import '../../intervention_models.dart';
import 'multiple_answer_intervention_bloc.dart';

class MultipleAnswerInterventionPage extends StatelessWidget {
  const MultipleAnswerInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EventResult eventResult;
  final MultipleAnswerInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider<GetInterventionUC, MultipleAnswerInterventionBloc>(
        update: (context, getInterventionUC, _) =>
            MultipleAnswerInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<MultipleAnswerInterventionBloc>(
          builder: (context, bloc, _) => MultipleAnswerInterventionPage(
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
    List<String> _likertAnswer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acompanhamentos'),
        backgroundColor: const Color(0xff125193),
      ),
      body: StreamBuilder(
        stream: bloc.onNewState,
        builder: (context, snapshot) =>
            AsyncSnapshotResponseView<Loading, Error, Success>(
          snapshot: snapshot,
          successWidgetBuilder: (successState) {
            final MultipleAnswerIntervention multipleAnswerIntervention =
                successState.intervention;

            _likertAnswer = List.filled(
                multipleAnswerIntervention.questionAnswers.length, '');

            return SensemActionListener(
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
              child: InterventionBody(
                statement: successState.intervention.statement,
                mediaInformation: successState.intervention.mediaInformation,
                nextPage: successState.nextPage,
                next: successState.intervention.next,
                nextInterventionType: successState.nextInterventionType,
                eventId: eventId,
                flowSize: flowSize,
                orderPosition: successState.intervention.orderPosition,
                onPressed: () {
                  var likertAnswerString = '';

                  for (var i = 0; i < _likertAnswer.length - 1; i++) {
                    likertAnswerString += _likertAnswer[i];
                    likertAnswerString += '_SEP_';
                    likertAnswerString += _likertAnswer[i + 1];
                  }

                  if (likertAnswerString == '_SEP_') {
                    likertAnswerString = '';
                  }

                  eventResult.interventionResultsList.add(
                    InterventionResult(
                      interventionType: InterventionType.multipleAnswer,
                      startTime: _startTime,
                      endTime: DateTime.now().millisecondsSinceEpoch,
                      interventionId: successState.intervention.interventionId,
                      answer: likertAnswerString,
                    ),
                  );

                  navigateToNextIntervention(
                    context,
                    successState.nextPage,
                    flowSize,
                    eventId,
                    successState.nextInterventionType,
                    eventResult,
                  );
                },
                child: Column(
                  children: [
                    ...multipleAnswerIntervention.questionAnswers
                        .asMap()
                        .map(
                          (index, optionText) => MapEntry(
                            index,
                            SingleOptionCard(
                              index: index,
                              optionText: optionText,
                              resultList: _likertAnswer,
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ],
                ),
              ),
            );
          },
          errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
        ),
      ),
    );
  }
}

class SingleOptionCard extends StatefulWidget {
  const SingleOptionCard({
    @required this.optionText,
    @required this.resultList,
    @required this.index,
  })  : assert(optionText != null),
        assert(resultList != null),
        assert(index != null);

  final String optionText;
  final int index;
  final List<String> resultList;

  @override
  State<StatefulWidget> createState() => SingleOptionCardState();
}

class SingleOptionCardState extends State<SingleOptionCard> {
  bool _checkBoxValue = false;

  @override
  Widget build(BuildContext context) => Card(
        color: SenSemColors.lightGray2,
        margin: const EdgeInsets.only(left: 8, right: 10, bottom: 15),
        child: Row(
          children: [
            Checkbox(
              value: _checkBoxValue,
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked) {
                    widget.resultList[widget.index] = widget.optionText;
                  } else {
                    widget.resultList[widget.index] = '';
                  }
                  _checkBoxValue = isChecked;
                });
              },
            ),
            Text(
              widget.optionText,
            ),
          ],
        ),
      );
}
