import 'package:domain/model/settings.dart';

import 'model/settings_cm.dart';

extension SettingsDMtoCM on Settings {
  SettingsCM toCM() => SettingsCM(
    isLandscape: isLandscape,
    isMobileNetworkEnabled: isMobileNetworkEnabled,
    isNotificationOnMediaEnabled: isMobileNetworkEnabled,
  );
}