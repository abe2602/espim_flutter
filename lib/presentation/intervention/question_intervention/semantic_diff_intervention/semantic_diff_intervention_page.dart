import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/semantic_diff_intervention/semantic_diff_intervention_bloc.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/semantic_diff_intervention/semantic_diff_intervention_models.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SemanticDiffInterventionPage extends StatefulWidget {
  const SemanticDiffInterventionPage({
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
    @required this.bloc,
  })  : assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EventResult eventResult;
  final int eventId;
  final int flowSize;
  final SemanticDiffInterventionBloc bloc;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider<GetInterventionUC, SemanticDiffInterventionBloc>(
        update: (context, getInterventionUC, _) => SemanticDiffInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<SemanticDiffInterventionBloc>(
          builder: (context, bloc, _) => SemanticDiffInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
            eventResult: eventResult,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => SemanticDiffInterventionPageState();
}

class SemanticDiffInterventionPageState
    extends State<SemanticDiffInterventionPage> {
  List<String> _likertAnswer;
  final _startTime = DateTime.now().millisecondsSinceEpoch;
  bool _shouldAlwaysDisplayValueIndicator = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: VisibilityDetector(
          key: UniqueKey(),
          onVisibilityChanged: (visibilityInfo) async {
            if (visibilityInfo.visibleFraction == 0.0) {
              _shouldAlwaysDisplayValueIndicator = false;
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: StreamBuilder<InterventionResponseState>(
                stream: widget.bloc.onNewState,
                builder: (context, snapshot) =>
                    AsyncSnapshotResponseView<Loading, Error, Success>(
                  snapshot: snapshot,
                  successWidgetBuilder: (successState) {
                    final SemanticDiffSuccess success = successState;
//                    _likertAnswer = List.filled(success.optionsList.length,
//                        '1: ${success.likertScales[0]}');

                    return InterventionBody(
                      statement: successState.intervention.statement,
                      mediaInformation:
                          successState.intervention.mediaInformation,
                      nextPage: successState.nextPage,
                      next: successState.intervention.next,
                      nextInterventionType: successState.nextInterventionType,
                      eventId: widget.eventId,
                      flowSize: widget.flowSize,
                      orderPosition: successState.intervention.orderPosition,
                      onPressed: () {
                        var likertAnswerString = '';

                        for (var i = 0; i < _likertAnswer.length - 1; i++) {
                          likertAnswerString += _likertAnswer[i];
                          likertAnswerString += '_SEP_';
                          likertAnswerString += _likertAnswer[i + 1];
                        }

                        widget.eventResult.interventionResultsList.add(
                          InterventionResult(
                            interventionType: 'question',
                            startTime: _startTime,
                            endTime: DateTime.now().millisecondsSinceEpoch,
                            interventionId:
                                successState.intervention.interventionId,
                            answer: likertAnswerString,
                          ),
                        );

                        setState(() {
                          _shouldAlwaysDisplayValueIndicator = false;
                        });

                        navigateToNextIntervention(
                          context,
                          successState.nextPage,
                          widget.flowSize,
                          widget.eventId,
                          successState.nextInterventionType,
                          widget.eventResult,
                        );
                      },
                      child: Column(
                        // todo: voltar aqui
                        children: [
                          ...success.likertScales
                              .asMap()
                              .map(
                                (index, statement) => MapEntry(
                                  index,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(statement),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: LikertCard(
                                          likertScale: success.likertScales,
                                          index: index,
                                          likertAnswer: _likertAnswer,
                                          shouldAlwaysDisplayValueIndicator:
                                              _shouldAlwaysDisplayValueIndicator,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .values
                              .toList(),
                        ],
                      ),
                    );
                  },
                  errorWidgetBuilder: (errorState) {
                    return Text('Eita');
                  },
                ),
              ),
            ),
          ),
        ),
      );
}
