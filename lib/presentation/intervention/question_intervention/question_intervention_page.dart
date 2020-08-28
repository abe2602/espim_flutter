import 'package:domain/model/question_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/validate_empty_field_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/form_text_field.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/question_intervention_bloc.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/question_intervention_models.dart';
import 'package:provider/provider.dart';

import '../intervention_models.dart';

class QuestionInterventionPage extends StatelessWidget {
  const QuestionInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null);

  final QuestionInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize) =>
      ProxyProvider2<GetInterventionUC, ValidateOpenQuestionTextUC,
          QuestionInterventionBloc>(
        update: (context, getInterventionUC, validateOpenQuestionTextUC, _) =>
            QuestionInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
          validateOpenQuestionTextUC: validateOpenQuestionTextUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<QuestionInterventionBloc>(
          builder: (context, bloc, _) => QuestionInterventionPage(
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
            margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
            child: StreamBuilder(
              stream: bloc.onNewState,
              builder: (context, snapshot) =>
                  AsyncSnapshotResponseView<Loading, Error, Success>(
                snapshot: snapshot,
                successWidgetBuilder: (successState) {
                  if (successState is OpenQuestionSuccess) {
                    return OpenQuestion(
                      bloc: bloc,
                      eventId: eventId,
                      flowSize: flowSize,
                      successState: successState,
                    );
                  } else if (successState is ClosedQuestionSuccess) {
                    return SensemActionListener(
                      actionStream: bloc.navigateToNextIntervention,
                      onReceived: (event) {
                        navigateToNextIntervention(context, event.item2,
                            flowSize, eventId, event.item1);
                      },
                      child: ClosedQuestion(
                        bloc: bloc,
                        eventId: eventId,
                        flowSize: flowSize,
                        successState: successState,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
              ),
            ),
          ),
        ),
      );
}

class ClosedQuestion extends StatefulWidget {
  const ClosedQuestion({
    @required this.bloc,
    @required this.successState,
    @required this.flowSize,
    @required this.eventId,
  })  : assert(bloc != null),
        assert(successState != null);

  final QuestionInterventionBloc bloc;
  final ClosedQuestionSuccess successState;
  final int flowSize;
  final int eventId;

  @override
  State<StatefulWidget> createState() => ClosedQuestionState();
}

class ClosedQuestionState extends State<ClosedQuestion> {
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
                Navigator.popUntil(context,
                    ModalRoute.withName(RouteNameBuilder.accompaniment));
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

class OpenQuestion extends StatefulWidget {
  const OpenQuestion({
    @required this.bloc,
    @required this.successState,
    @required this.flowSize,
    @required this.eventId,
  })  : assert(bloc != null),
        assert(successState != null);

  final QuestionInterventionBloc bloc;
  final OpenQuestionSuccess successState;
  final int flowSize;
  final int eventId;

  @override
  State<StatefulWidget> createState() => OpenQuestionState();
}

class OpenQuestionState extends State<OpenQuestion> {
  final _openQuestionFocusNode = FocusNode();
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
          navigateToNextIntervention(
            context,
            widget.successState.nextPage,
            widget.flowSize,
            widget.eventId,
            widget.successState.nextInterventionType,
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
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 10),

                        /// The correct way to do this is: bring all code from
                        /// formtextfield to this Widget, but I want to have an example
                        /// from this widget usage.
                        child: FormTextField(
                          statusStream:
                              widget.bloc.openQuestionInputStatusStream,
                          focusNode: _openQuestionFocusNode,
                          labelText: S.of(context).openQuestionLabel,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          boxColor: boxColor,
                          onChanged:
                              widget.bloc.onOpenQuestionValueChangedSink.add,
                        ),
                      ),
                      if (snapshot.data == InputStatusVM.empty)
                        Container(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 5),
                          alignment: Alignment.centerRight,
                          child: Text(
                            S.of(context).emptyFieldError,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      else
                        Container(),
                    ],
                  )),
        ),
      );
}
