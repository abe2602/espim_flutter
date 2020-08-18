import 'dart:async';

import 'package:rxdart/rxdart.dart';

mixin SubscriptionBag {
  final CompositeSubscription subscriptionsBag = CompositeSubscription();

  void disposeAll() {
    subscriptionsBag.clear();
  }
}

extension AddToStreamSubscription<T> on StreamSubscription<T> {
  void addTo(CompositeSubscription compositeSubscription) =>
      compositeSubscription.add(this);
}
