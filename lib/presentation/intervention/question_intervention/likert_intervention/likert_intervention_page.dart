import 'package:domain/model/event_result.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/custom_slider.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:provider/provider.dart';

import 'likert_intervention_bloc.dart';
import 'likert_intervention_models.dart';

class LikertInterventionPage extends StatefulWidget {
  const LikertInterventionPage({
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
  final LikertInterventionBloc bloc;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider<GetInterventionUC, LikertInterventionBloc>(
        update: (context, getInterventionUC, _) => LikertInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<LikertInterventionBloc>(
          builder: (context, bloc, _) => LikertInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
            eventResult: eventResult,
          ),
        ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: StreamBuilder<InterventionResponseState>(
              stream: widget.bloc.onNewState,
              builder: (context, snapshot) =>
                  AsyncSnapshotResponseView<Loading, Error, Success>(
                snapshot: snapshot,
                successWidgetBuilder: (successState) {
                  final LikertSuccess success = successState;

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
                    onPressed: () {},
                    child: Column(
                      children: [
                        ...success.optionsList.map(
                          (statement) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(statement),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: LikertCard(
                                    likertScale: success.likertScales),
                              ),
                            ],
                          ),
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
        ),
      );
}

class LikertCard extends StatefulWidget {
  const LikertCard({
    @required this.likertScale,
  }) : assert(likertScale != null);

  final List<String> likertScale;

  @override
  State<StatefulWidget> createState() => LikertCardState();
}

class LikertCardState extends State<LikertCard> {
  double _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = 0.0;
  }

  @override
  Widget build(BuildContext context) => Container(
        color: SenSemColors.accentLightGray,
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: SenSemColors.lightGray,
                inactiveTrackColor: SenSemColors.lightGray,
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                thumbColor: SenSemColors.windowBlue,
                overlayColor: SenSemColors.primaryColor.withAlpha(32),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
                tickMarkShape:
                    const RoundSliderTickMarkShape(tickMarkRadius: 6),
                activeTickMarkColor: SenSemColors.lightGray,
                inactiveTickMarkColor: SenSemColors.lightGray,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: SenSemColors.windowBlue,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: CustomSlider(
                shouldAlwaysDisplayValueIndicator: true,
                value: _selectedOption,
                min: 0,
                max: widget.likertScale.length.toDouble() - 1,
                divisions: widget.likertScale.length - 1,
                label: '${(_selectedOption + 1).toInt()}. '
                    '${widget.likertScale[_selectedOption.floor()]}',
                onChanged: (value) {
                  setState(
                    () {
                      _selectedOption = value;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ...widget.likertScale
                        .asMap()
                        .map(
                          (index, _) => MapEntry(
                            index,
                            Text(
                              (index + 1).toString(),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ]),
            ),
          ],
        ),
      );
}
