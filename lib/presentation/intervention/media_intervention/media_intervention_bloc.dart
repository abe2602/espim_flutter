import 'dart:io';

import 'package:domain/model/media_intervention.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/upload_file_uc.dart';
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
    @required this.uploadFileUC,
  })  : assert(eventId != null),
        assert(orderPosition != null),
        assert(uploadFileUC != null),
        assert(getInterventionUC != null) {
    MergeStream([
      _getIntervention(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);

    _onActionEventSubject
        .flatMap(_uploadFile)
        .listen(_onActionEventResultSubject.add)
        .addTo(subscriptionsBag);
  }

  final int eventId;
  final int orderPosition;
  final GetInterventionUC getInterventionUC;
  final UploadFileUC uploadFileUC;

  final _onNewStateSubject = BehaviorSubject<InterventionResponseState>();
  final _onActionEventSubject = PublishSubject<File>();
  final _onActionEventResultSubject =
      PublishSubject<InterventionResponseState>();

  Sink<File> get onActionEventSink => _onActionEventSubject.sink;

  Stream<InterventionResponseState> get onActionEventStream =>
      _onActionEventResultSubject.stream;

  Stream<InterventionResponseState> get onNewState => _onNewStateSubject.stream;

  Stream<InterventionResponseState> _getIntervention() async* {
    yield Loading();

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
          nextPage: currentIntervention.next,
          intervention: currentIntervention,
          nextInterventionType: nextIntervention.type);
    } catch (error) {
      print('erro no bloc  ' + error.toString());
    }
  }

  Stream<InterventionResponseState> _uploadFile(File file) async* {
    yield UploadLoading();

    try {
      final mediaUrl =
          await uploadFileUC.getFuture(params: UploadFileUCParams(file: file));
      final Success previousSuccess = _onNewStateSubject.value;

      yield Success(
        nextInterventionType: previousSuccess.nextInterventionType,
        nextPage: previousSuccess.nextPage,
        mediaUrl: mediaUrl,
        intervention: previousSuccess.intervention,
      );
    } catch (error) {
      print('erro no bloc  ' + error.toString());
    }
  }

  void dispose() {
    _onActionEventResultSubject.close();
    _onActionEventSubject.close();
    _onNewStateSubject.close();
  }
}
