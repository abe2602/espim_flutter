import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'settings_cm.g.dart';

@HiveType(typeId: 10)
class SettingsCM {
  const SettingsCM({
    @required this.isLandscape,
    @required this.isMobileNetworkEnabled,
    @required this.isNotificationOnMediaEnabled,
  })  : assert(isLandscape != null),
        assert(isMobileNetworkEnabled != null),
        assert(isNotificationOnMediaEnabled != null);

  @HiveField(0)
  final bool isLandscape;

  @HiveField(1)
  final bool isMobileNetworkEnabled;

  @HiveField(2)
  final bool isNotificationOnMediaEnabled;
}
