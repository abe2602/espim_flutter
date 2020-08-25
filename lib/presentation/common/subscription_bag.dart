import 'dart:async';

import 'package:rxdart/rxdart.dart';

mixin SubscriptionBag {
  final CompositeSubscription subscriptionsBag = CompositeSubscription();

  void disposeAll() {
    subscriptionsBag.clear();
  }
}

extension AddToStreamSubscription<T> on StreamSubscription<T> {
  void senSemAddTo(CompositeSubscription compositeSubscription) =>
      compositeSubscription.add(this);
}
