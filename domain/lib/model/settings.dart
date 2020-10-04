import 'package:meta/meta.dart';

class Settings {
  const Settings({
    @required this.isLandscape,
    @required this.isMobileNetworkEnabled,
    @required this.isNotificationOnMediaEnabled,
  })  : assert(isLandscape != null),
        assert(isMobileNetworkEnabled != null),
        assert(isNotificationOnMediaEnabled != null);

  final bool isLandscape;

  final bool isMobileNetworkEnabled;

  final bool isNotificationOnMediaEnabled;
}
