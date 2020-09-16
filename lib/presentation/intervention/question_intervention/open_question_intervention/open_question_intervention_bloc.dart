import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/validate_empty_field_uc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'open_question_intervention_models.dart';

class OpenQuestionInterventionBloc with SubscriptionBag {
  OpenQuestionInterventionBloc(
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
          (_) => _buildOpenQuestionValidationStream(
              _openQuestionTextInputStatusSubject),
        )
        .addTo(subscriptionsBag);

    _navigateToNextInterventionSubject
        .flatMap((_) => _getNextIntervention())
        .listen(_onClosedQuestionNewActionSubject.add)
        .addTo(subscriptionsBag);

    _onNavigationActionSubject.stream
        .flatMap(
          (_) => Future.wait(
            [
              _buildOpenQuestionValidationStream(
                  _openQuestionTextInputStatusSubject),
            ],
            eagerError: false,
          ).asStream(),
        )
        .listen(_onOpenQuestionNewAction.add)
        .addTo(subscriptionsBag);
  }

  final int eventId;
  final int orderPosition;
  final ValidateOpenQuestionTextUC validateOpenQuestionTextUC;
  final GetInterventionUC getInterventionUC;

  final _onOpenQuestionTextFocusLostSubject = PublishSubject<void>();
  final _onOpenQuestionTextValueChangedSubject = BehaviorSubject<String>();
  final _openQuestionTextInputStatusSubject = PublishSubject<InputStatusVM>();
  final _onNavigationActionSubject = PublishSubject<void>();
  final _onOpenQuestionNewAction = PublishSubject<void>();
  final _onNewStateSubject = BehaviorSubject<InterventionResponseState>();
  final _onTryAgainSubject = PublishSubject<InterventionResponseState>();
  final _onClosedQuestionNewActionSubject =
      PublishSubject<Tuple2<String, int>>();
  final _navigateToNextInterventionSubject = BehaviorSubject<int>();

  String nextInterventionClosedQuestion = '';

  Stream<InputStatusVM> get openQuestionInputStatusStream =>
      _openQuestionTextInputStatusSubject.stream;

  Stream<void> get aux =>
      _onOpenQuestionNewAction.stream;

  Stream<void> get onNavigationActionStream =>
      _onNavigationActionSubject.stream;

  Sink<void> get onOpenQuestionFocusLostSink =>
      _onOpenQuestionTextFocusLostSubject.sink;

  Sink<void> get onNavigateNewActionSink => _onNavigationActionSubject.sink;

  Sink<String> get onOpenQuestionValueChangedSink =>
      _onOpenQuestionTextValueChangedSubject.sink;

  Sink<int> get navigateToNextInterventionSink =>
      _navigateToNextInterventionSubject.sink;

  Sink<Tuple2<String, int>> get onNewActionSubjectSink =>
      _onClosedQuestionNewActionSubject.sink;

  String get openQuestionText =>
      _onOpenQuestionTextValueChangedSubject.stream.value;

  Stream<InterventionResponseState> get onNewState => _onNewStateSubject;

  Stream<Tuple2<String, int>> get navigateToNextIntervention =>
      _onClosedQuestionNewActionSubject;

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

      yield OpenQuestionSuccess(
          nextPage: currentIntervention.next,
          intervention: currentIntervention,
          nextInterventionType: nextIntervention.type);

    } catch (error) {
      print('erro no bloc  ' + error.toString());
    }
  }

  Future<void> _buildOpenQuestionValidationStream(Sink<InputStatusVM> sink) =>
      validateOpenQuestionTextUC
          .getFuture(
            params: ValidateOpenQuestionTextUCParams(openQuestionText),
          )
          .addStatusToSink(sink);

  void dispose() {
    _onOpenQuestionNewAction.close();
    _openQuestionTextInputStatusSubject.close();
    _onOpenQuestionTextValueChangedSubject.close();
    _navigateToNextInterventionSubject.close();
    _onClosedQuestionNewActionSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    _onNavigationActionSubject.close();
  }
}
