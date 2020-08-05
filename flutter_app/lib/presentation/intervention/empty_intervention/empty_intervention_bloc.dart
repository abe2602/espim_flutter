import 'package:domain/model/empty_intervention.dart';
import 'package:flutter/widgets.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/intervention/empty_intervention/empty_intervention_models.dart';
import 'package:rxdart/rxdart.dart';

class EmptyInterventionBloc with SubscriptionBag {
  EmptyInterventionBloc(
      {@required this.eventId,
      @required this.pageNumber,
      @required this.getInterventionUC})
      : assert(eventId != null),
        assert(pageNumber != null),
        assert(getInterventionUC != null) {
    MergeStream([
      _getIntervention(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);
  }

  final int eventId;
  final int pageNumber;

  final GetInterventionUC getInterventionUC;

  final _onNewStateSubject = BehaviorSubject<EmptyInterventionResponseState>();
  final _onTryAgainSubject = PublishSubject<EmptyInterventionResponseState>();

  Stream<EmptyInterventionResponseState> get onNewState => _onNewStateSubject;

  Stream<EmptyInterventionResponseState> _getIntervention() async* {
    try {
      final EmptyIntervention emptyIntervention =
          await getInterventionUC.getFuture(
        params:
            GetInterventionUCParams(eventId: eventId, pageNumber: pageNumber),
      );

      yield Success(intervention: emptyIntervention);
    } catch (error) {
      print('erro no bloc  ' + error.toString());
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
  }
}
