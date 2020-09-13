import 'package:domain/model/intervention.dart';
import 'package:domain/model/semantic_diff_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/semantic_diff_intervention/semantic_diff_intervention_models.dart';
import 'package:rxdart/rxdart.dart';

class SemanticDiffInterventionBloc with SubscriptionBag {
  SemanticDiffInterventionBloc({
    @required this.eventId,
    @required this.orderPosition,
    @required this.getInterventionUC,
  })  : assert(eventId != null),
        assert(orderPosition != null),
        assert(getInterventionUC != null) {
    MergeStream([
      _getIntervention(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);
  }

  final int eventId;
  final int orderPosition;
  final GetInterventionUC getInterventionUC;

  final _onNewStateSubject = BehaviorSubject<InterventionResponseState>();

  Stream<InterventionResponseState> get onNewState => _onNewStateSubject;

  Stream<InterventionResponseState> _getIntervention() async* {
    yield Loading();

    try {
      Intervention nextIntervention;
      final SemanticDiffIntervention currentIntervention =
      await getInterventionUC.getFuture(
        params: GetInterventionUCParams(
            eventId: eventId, positionOrder: orderPosition),
      );

      if (currentIntervention.next != 0) {
        nextIntervention = await getInterventionUC.getFuture(
          params: GetInterventionUCParams(
              eventId: eventId, positionOrder: currentIntervention.next),
        );
      }

      yield SemanticDiffSuccess(
        nextPage: currentIntervention.next,
        intervention: currentIntervention,
        nextInterventionType: nextIntervention?.type ?? '',
        likertScales: getLikertScales(currentIntervention.scales[0]),
      );
    } catch (error) {
      print(error.toString());
    }
  }

  void dispose() {
    _onNewStateSubject.close();
  }
}

List<String> getLikertScales(String likertScale) {
  switch (likertScale) {
    case '5 AGREEMENT':
      return [
        'Strongly disagree',
        'Disagree',
        'Neutral',
        'Agree',
        'Strongly Agree'
      ];
      break;
    case '7 AGREEMENT':
      return [
        'Strongly disagree',
        'Somewhat disagree',
        'Disagree',
        'Neutral',
        'Somewhat agree',
        'Agree',
        'Strongly Agree'
      ];
      break;
    case '5 FREQUENCY':
      return ['Never', 'Rarely', 'Sometime', 'Often', 'Always'];
      break;
    case '7 FREQUENCY':
      return [
        'Never',
        'Almost never',
        'Rarely',
        'Sometime',
        'Often',
        'Almost always',
        'Always'
      ];
      break;
    case '5 SATISFACTION':
      return [
        'Very dissatisfied',
        'Dissatisfied',
        'Neutral',
        'Satisfied',
        'Very Satisfied'
      ];
      break;
    case '7 SATISFACTION':
      return [
        'Very dissatisfied',
        'Dissatisfied',
        'Somewhat dissatisfied',
        'Neutral',
        'Somewhat satisfied',
        'Satisfied',
        'Very satisfied'
      ];
      break;
    default:
      return [];
      break;
  }
}
