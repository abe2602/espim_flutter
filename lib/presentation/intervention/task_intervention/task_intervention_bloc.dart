import 'package:domain/model/intervention.dart';
import 'package:domain/model/task_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';
import 'package:rxdart/rxdart.dart';

import 'task_intervention_models.dart';

class TaskInterventionBloc with SubscriptionBag {
  TaskInterventionBloc(
      {@required this.eventId,
      @required this.orderPosition,
      @required this.flowSize,
      @required this.getInterventionUC})
      : assert(eventId != null),
        assert(orderPosition != null),
        assert(getInterventionUC != null) {
    MergeStream([
      _getIntervention(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);
  }

  final int eventId;
  final int orderPosition;
  final int flowSize;

  final GetInterventionUC getInterventionUC;

  final _onNewStateSubject = BehaviorSubject<InterventionResponseState>();
  final _onTryAgainSubject = PublishSubject<InterventionResponseState>();

  Stream<InterventionResponseState> get onNewState => _onNewStateSubject;

  Stream<InterventionResponseState> _getIntervention() async* {
    yield Loading();

    try {
      Intervention nextIntervention;
      final TaskIntervention currentIntervention =
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

      yield TaskInterventionSuccess(
          appPackage: currentIntervention.appPackage,
          taskParameters: currentIntervention.taskParameters,
          startFromNotification: currentIntervention.startFromNotification,
          nextPage: currentIntervention.next,
          intervention: currentIntervention,
          nextInterventionType: nextIntervention?.type ?? '');
    } catch (error) {
      print(error.toString());
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
  }
}
