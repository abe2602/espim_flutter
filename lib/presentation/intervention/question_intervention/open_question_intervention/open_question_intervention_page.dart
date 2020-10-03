import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/validate_empty_field_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/form_text_field.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/intervention_body.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/open_question_intervention/open_question_intervention_bloc.dart';
import 'package:provider/provider.dart';

import '../../intervention_models.dart';
import 'open_question_intervention_models.dart';

class OpenQuestionInterventionPage extends StatelessWidget {
  const OpenQuestionInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EventResult eventResult;
  final OpenQuestionInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider2<GetInterventionUC, ValidateOpenQuestionTextUC,
          OpenQuestionInterventionBloc>(
        update: (context, getInterventionUC, validateOpenQuestionTextUC, _) =>
            OpenQuestionInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
          validateOpenQuestionTextUC: validateOpenQuestionTextUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<OpenQuestionInterventionBloc>(
          builder: (context, bloc, _) => OpenQuestionInterventionPage(
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
            AsyncSnapshotResponseView<Loading, Error, Success>(
          snapshot: snapshot,
          successWidgetBuilder: (successState) => OpenQuestion(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
            successState: successState,
            eventResult: eventResult,
          ),
          errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
        ),
      ),
    );
  }
}

class OpenQuestion extends StatefulWidget {
  const OpenQuestion({
    @required this.bloc,
    @required this.successState,
    @required this.flowSize,
    @required this.eventId,
    @required this.eventResult,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null),
        assert(successState != null);

  final OpenQuestionInterventionBloc bloc;
  final OpenQuestionSuccess successState;
  final EventResult eventResult;
  final int flowSize;
  final int eventId;

  @override
  State<StatefulWidget> createState() => OpenQuestionState();
}

class OpenQuestionState extends State<OpenQuestion> {
  final _openQuestionFocusNode = FocusNode();
  final _startTime = DateTime.now().millisecondsSinceEpoch;
  Color boxColor = SenSemColors.primaryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _openQuestionFocusNode.addFocusLostListener(
        () => widget.bloc.onOpenQuestionFocusLostSink.add(null));
  }

  @override
  Widget build(BuildContext context) => SensemActionListener(
        onReceived: (event) {
          widget.eventResult.interventionResultsList.add(
            InterventionResult(
              interventionType: widget.successState.intervention.type,
              startTime: _startTime,
              endTime: DateTime.now().millisecondsSinceEpoch,
              interventionId: widget.successState.intervention.interventionId,
              answer: widget.bloc.openQuestionText,
            ),
          );

          widget.eventResult.interventionsIds
              .add(widget.successState.intervention.interventionId);

          navigateToNextIntervention(
            context,
            widget.successState.nextPage,
            widget.flowSize,
            widget.eventId,
            widget.successState.nextInterventionType,
            widget.eventResult,
          );
        },
        actionStream: widget.bloc.aux,
        child: InterventionBody(
          statement: widget.successState.intervention.statement,
          mediaInformation: widget.successState.intervention.mediaInformation,
          nextPage: widget.successState.nextPage,
          next: widget.successState.intervention.next,
          nextInterventionType: widget.successState.nextInterventionType,
          eventId: widget.eventId,
          flowSize: widget.flowSize,
          orderPosition: widget.successState.intervention.orderPosition,
          onPressed: () {
            widget.bloc.onNavigateNewActionSink.add(null);
          },
          child: StreamBuilder<InputStatusVM>(
            stream: widget.bloc.openQuestionInputStatusStream,
            initialData: InputStatusVM.undefined,
            builder: (context, snapshot) => Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 10),

                  /// The correct way to do this is: bring all code from
                  /// formtextfield to this Widget, but I want to have an example
                  /// from this widget usage.
                  child: FormTextField(
                    statusStream: widget.bloc.openQuestionInputStatusStream,
                    focusNode: _openQuestionFocusNode,
                    labelText: S.of(context).open_question_label,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    boxColor: boxColor,
                    onChanged: widget.bloc.onOpenQuestionValueChangedSink.add,
                  ),
                ),
                if (snapshot.data == InputStatusVM.empty)
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 5),
                    alignment: Alignment.centerRight,
                    child: Text(
                      S.of(context).empty_field_error,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                else
                  Container(),
              ],
            ),
          ),
        ),
      );
}
