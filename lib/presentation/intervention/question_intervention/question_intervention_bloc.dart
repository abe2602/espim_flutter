import 'package:domain/model/question_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/validate_empty_field_uc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/question_intervention_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class QuestionInterventionBloc with SubscriptionBag {
  QuestionInterventionBloc(
      {@required this.eventId,
      @required this.orderPosition,
      @required this.getInterventionUC,
      @required this.validateOpenQuestionTextUC})
      : assert(eventId != null),
        assert(orderPosition != null),
        assert(getInterventionUC != null),
        assert(validateOpenQuestionTextUC != null) {
    MergeStream([
      _getIntervention(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);

    _onOpenQuestionTextFocusLostSubject
        .listen(
          (_) => _buildUserFullNameValidationStream(
              _openQuestionTextInputStatusSubject),
        )
        .addTo(subscriptionsBag);

    _navigateToNextInterventionSubject
        .flatMap((_) => _getNextIntervention())
        .listen(_onNewActionSubject.add)
        .addTo(subscriptionsBag);
  }

  final int eventId;
  final int orderPosition;
  final ValidateOpenQuestionTextUC validateOpenQuestionTextUC;
  final GetInterventionUC getInterventionUC;

  final _onOpenQuestionTextFocusLostSubject = PublishSubject<void>();
  final _onOpenQuestionTextValueChangedSubject = BehaviorSubject<String>();
  final _openQuestionTextInputStatusSubject = PublishSubject<InputStatusVM>();

  final _onNewStateSubject = BehaviorSubject<InterventionResponseState>();
  final _onTryAgainSubject = PublishSubject<InterventionResponseState>();
  final _onNewActionSubject = PublishSubject<Tuple2<String, int>>();
  final _navigateToNextInterventionSubject = BehaviorSubject<int>();

  String nextInterventionClosedQuestion = '';

  Stream<InputStatusVM> get openQuestionInputStatusStream =>
      _openQuestionTextInputStatusSubject.stream;

  Sink<void> get onOpenQuestionFocusLostSink =>
      _onOpenQuestionTextFocusLostSubject.sink;

  Sink<String> get onOpenQuestionValueChangedSink =>
      _onOpenQuestionTextValueChangedSubject.sink;

  Sink<int> get navigateToNextInterventionSink =>
      _navigateToNextInterventionSubject.sink;

  Sink<Tuple2<String, int>> get onNewActionSubjectSink =>
      _onNewActionSubject.sink;

  String get openQuestionText =>
      _onOpenQuestionTextValueChangedSubject.stream.value;

  Stream<InterventionResponseState> get onNewState => _onNewStateSubject;

  Stream<Tuple2<String, int>> get navigateToNextIntervention =>
      _onNewActionSubject;

  Stream<Tuple2<String, int>> _getNextIntervention() async* {
    try {
      final newIntervention = await getInterventionUC.getFuture(
        params: GetInterventionUCParams(
            eventId: eventId,
            positionOrder: _navigateToNextInterventionSubject.value),
      );

      yield Tuple2(
          newIntervention.type, _navigateToNextInterventionSubject.value);
    } catch (e) {}
  }

  Stream<InterventionResponseState> _getIntervention() async* {
    yield Loading();

    try {
      final currentIntervention = await getInterventionUC.getFuture(
        params: GetInterventionUCParams(
            eventId: eventId, positionOrder: orderPosition),
      );

      final nextIntervention = await getInterventionUC.getFuture(
        params: GetInterventionUCParams(
            eventId: eventId, positionOrder: currentIntervention.next),
      );

      if (currentIntervention is QuestionIntervention &&
          currentIntervention.questionType == 0) {
        yield OpenQuestionSuccess(
            nextPage: currentIntervention.next,
            intervention: currentIntervention,
            nextInterventionType: nextIntervention.type);
      } else {
        yield ClosedQuestionSuccess(
            nextPage: currentIntervention.next,
            intervention: currentIntervention,
            nextInterventionType: nextIntervention.type);
      }
    } catch (error) {
      print('erro no bloc  ' + error.toString());
    }
  }

  Future<void> _buildUserFullNameValidationStream(Sink<InputStatusVM> sink) =>
      validateOpenQuestionTextUC
          .getFuture(
            params: ValidateOpenQuestionTextUCParams(openQuestionText),
          )
          .addStatusToSink(sink);

  void dispose() {
    _openQuestionTextInputStatusSubject.close();
    _onOpenQuestionTextValueChangedSubject.close();
    _navigateToNextInterventionSubject.close();
    _onNewActionSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
  }
}
