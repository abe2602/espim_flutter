import 'package:domain/model/media_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:rxdart/rxdart.dart';

import 'media_intervention_models.dart';

class MediaInterventionBloc with SubscriptionBag {
  MediaInterventionBloc({
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
    try {
      final MediaIntervention currentIntervention =
          await getInterventionUC.getFuture(
        params: GetInterventionUCParams(
            eventId: eventId, positionOrder: orderPosition),
      );

      final nextIntervention = await getInterventionUC.getFuture(
        params: GetInterventionUCParams(
            eventId: eventId, positionOrder: currentIntervention.next),
      );

      yield MediaInterventionSuccess(
          mediaType: currentIntervention.mediaType,
          nextPage: currentIntervention.next,
          intervention: currentIntervention,
          nextInterventionType: nextIntervention.type);
    } catch (error) {
      print('erro no bloc  ' + error.toString());
    }
  }

  void dispose() {
    _onNewStateSubject.close();
  }
}
