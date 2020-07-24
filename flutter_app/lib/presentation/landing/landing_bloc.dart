import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:domain/use_case/mark_landing_page_as_seen_uc.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';

class LandingBloc with SubscriptionBag {
  LandingBloc({@required this.markLandingPageAsSeenUC})
      : assert(markLandingPageAsSeenUC != null) {
    _onMarkLandingPageAsSeen.stream
        .flatMap((value) => markLandingPageAsSeen())
        .listen(_onNewActionEvent.add)
        .addTo(subscriptionsBag);
  }

  final MarkLandingPageAsSeenUC markLandingPageAsSeenUC;
  final _onMarkLandingPageAsSeen = StreamController<void>();
  final _onNewActionEvent = StreamController<void>();

  Sink<void> get onMarkLandingPageAsSeen => _onMarkLandingPageAsSeen.sink;

  Stream<void> get onActionEvent =>
      _onNewActionEvent.stream;

  Stream<void> markLandingPageAsSeen() async* {
    try {
      await markLandingPageAsSeenUC.getFuture();
      yield* Stream.value(null);
    } catch (e) {
      yield* Stream.value(null);
    }
  }

  void dispose() {
    _onNewActionEvent.close();
    _onMarkLandingPageAsSeen.close();
  }
}