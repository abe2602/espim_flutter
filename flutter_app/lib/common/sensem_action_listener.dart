import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';

class SensemActionListener<T> extends StatefulWidget {
  const SensemActionListener({
    @required this.child,
    @required this.actionStream,
    @required this.onReceived,
    Key key,
  })  : assert(child != null),
        assert(actionStream != null),
        assert(onReceived != null),
        super(key: key);

  final Widget child;
  final Stream<T> actionStream;
  final Function(T action) onReceived;

  @override
  _SensemActionListenerState<T> createState() =>
      _SensemActionListenerState<T>();
}

class _SensemActionListenerState<T> extends State<SensemActionListener<T>>
    with SubscriptionBag {
  @override
  void initState() {
    widget.actionStream
        .listen(
          widget.onReceived,
        )
        .addTo(subscriptionsBag);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    disposeAll();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
