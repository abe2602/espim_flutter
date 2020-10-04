import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/model/intervention_type.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/intervention_body.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'file:///C:/Users/Abe/Desktop/Programming/espim_flutter/lib/presentation/common/likert_card.dart';

import 'custom_likert_intervention_bloc.dart';
import 'custom_likert_intervention_models.dart';

class CustomLikertInterventionPage extends StatefulWidget {
  const CustomLikertInterventionPage({
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
  final CustomLikertInterventionBloc bloc;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider<GetInterventionUC, CustomLikertInterventionBloc>(
        update: (context, getInterventionUC, _) => CustomLikertInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<CustomLikertInterventionBloc>(
          builder: (context, bloc, _) => CustomLikertInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
            eventResult: eventResult,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => CustomLikertInterventionPageState();
}

class CustomLikertInterventionPageState
    extends State<CustomLikertInterventionPage> {
  final _startTime = DateTime.now().millisecondsSinceEpoch;
  final _visibilityKey = UniqueKey();
  bool _shouldAlwaysDisplayValueIndicator = true;
  List<String> _likertAnswer;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: VisibilityDetector(
          key: _visibilityKey,
          onVisibilityChanged: (visibilityInfo) async {
            if (visibilityInfo.visibleFraction == 1) {
              setState(() {
                _shouldAlwaysDisplayValueIndicator = true;
              });
            }
          },
          child: StreamBuilder<InterventionResponseState>(
            stream: widget.bloc.onNewState,
            builder: (context, snapshot) =>
                AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              successWidgetBuilder: (successState) {
                final CustomLikertSuccess success = successState;
                _likertAnswer = List.filled(success.likertScales.length,
                    '1: ${success.likertScales[0]}');

                return InterventionBody(
                  statement: successState.intervention.statement,
                  mediaInformation: successState.intervention.mediaInformation,
                  nextPage: successState.nextPage,
                  next: successState.intervention.next,
                  nextInterventionType: successState.nextInterventionType,
                  eventId: widget.eventId,
                  flowSize: widget.flowSize,
                  orderPosition: successState.intervention.orderPosition,
                  onPressed: () {
                    widget.eventResult.interventionResultsList.add(
                      InterventionResult(
                        interventionType: InterventionType.customLikert,
                        startTime: _startTime,
                        endTime: DateTime.now().millisecondsSinceEpoch,
                        interventionId:
                            successState.intervention.interventionId,
                        answer: createLikertTypeResponse(
                            _likertAnswer.length - 1, _likertAnswer),
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: LikertCard(
                              likertScale: success.likertScales,
                              index: 0,
                              likertAnswer: _likertAnswer,
                              shouldAlwaysDisplayValueIndicator:
                                  _shouldAlwaysDisplayValueIndicator,
                            ),
                          ),
                        ],
                      ),
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
      );
}
