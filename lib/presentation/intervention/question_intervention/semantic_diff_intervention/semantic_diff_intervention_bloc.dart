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

      final semanticDiffScales =
          List.filled(int.parse(currentIntervention.scales[0]), '');

      final index = int.parse(currentIntervention.scales[0]) ~/ 2;
      var valuePositive = 0, valueNegative = 0, i = index - 1, j = index + 1;
      semanticDiffScales[index] = '0';

      while (i >= 0) {
        semanticDiffScales[i] = (valueNegative - 1).toString();
        semanticDiffScales[j] = (valuePositive + 1).toString();
        i--;
        j++;
        valueNegative--;
        valuePositive++;
      }

      yield SemanticDiffSuccess(
        semanticDiffScale: semanticDiffScales,
        semanticDiffSize: int.parse(currentIntervention.scales[0]),
        semanticDiffLabels: currentIntervention.scales
            .sublist(1, currentIntervention.scales.length),
        nextPage: currentIntervention.next,
        intervention: currentIntervention,
        nextInterventionType: nextIntervention?.type ?? '',
      );
    } catch (error) {
      print(error.toString());
    }
  }

  void dispose() {
    _onNewStateSubject.close();
  }
}
