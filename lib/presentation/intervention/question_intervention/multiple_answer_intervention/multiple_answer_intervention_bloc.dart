import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/multiple_answer_intervention/multiple_answer_intervention_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class MultipleAnswerInterventionBloc with SubscriptionBag {
  MultipleAnswerInterventionBloc({
    @required this.eventId,
    @required this.orderPosition,
    @required this.getInterventionUC,
  })  : assert(eventId != null),
        assert(orderPosition != null),
        assert(getInterventionUC != null) {
    MergeStream([
      _getIntervention(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);

    _navigateToNextInterventionSubject
        .flatMap((_) => _getNextIntervention())
        .listen(_onClosedQuestionNewActionSubject.add)
        .addTo(subscriptionsBag);
  }

  final int eventId;
  final int orderPosition;
  final GetInterventionUC getInterventionUC;

  final _onNavigationActionSubject = PublishSubject<void>();
  final _onNewStateSubject = BehaviorSubject<InterventionResponseState>();
  final _onTryAgainSubject = PublishSubject<InterventionResponseState>();
  final _onClosedQuestionNewActionSubject =
  PublishSubject<Tuple2<String, int>>();
  final _navigateToNextInterventionSubject = BehaviorSubject<int>();

  String nextInterventionClosedQuestion = '';

  Stream<void> get onNavigationActionStream =>
      _onNavigationActionSubject.stream;

  Sink<void> get onNavigateNewActionSink => _onNavigationActionSubject.sink;

  Sink<int> get navigateToNextInterventionSink =>
      _navigateToNextInterventionSubject.sink;

  Sink<Tuple2<String, int>> get onNewActionSubjectSink =>
      _onClosedQuestionNewActionSubject.sink;

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

      yield MultipleAnswerInterventionSuccess(
          nextPage: currentIntervention.next,
          intervention: currentIntervention,
          nextInterventionType: nextIntervention.type);

    } catch (error) {
      print('erro no bloc  ' + error.toString());
    }
  }

  void dispose() {
    _navigateToNextInterventionSubject.close();
    _onClosedQuestionNewActionSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    _onNavigationActionSubject.close();
  }
}
