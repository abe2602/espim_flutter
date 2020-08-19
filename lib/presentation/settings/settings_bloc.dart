import 'package:domain/model/settings.dart';
import 'package:domain/use_case/change_settings_uc.dart';
import 'package:domain/use_case/get_settings_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/settings/settings_models.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc with SubscriptionBag {
  SettingsBloc({
    @required this.getSettingsUC,
    @required this.changeSettingsUC,
  })  : assert(getSettingsUC != null),
        assert(changeSettingsUC != null) {
    MergeStream([
      _getSettings(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);

    _onChangeOrientationSubject
        .flatMap(
          (value) => _changeOrientation(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptionsBag);

    _onEnableMobileNetworkSubject
        .flatMap(
          (value) => _changeNetworkSource(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptionsBag);

    _onEnableNotificationSubject
        .flatMap(
          (value) => _allowNotification(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptionsBag);
  }

  final GetSettingsUC getSettingsUC;
  final ChangeSettingsUC changeSettingsUC;
  final _onNewStateSubject = BehaviorSubject<SettingsResponseState>();
  final _onChangeOrientationSubject = PublishSubject<void>();
  final _onEnableMobileNetworkSubject = PublishSubject<void>();
  final _onEnableNotificationSubject = PublishSubject<void>();

  Stream<SettingsResponseState> get onNewState => _onNewStateSubject;

  Sink<void> get onChangeOrientationSink => _onChangeOrientationSubject.sink;

  Sink<void> get onEnableMobileNetworkSink =>
      _onEnableMobileNetworkSubject.sink;

  Sink<void> get onEnableNotificationSink => _onEnableNotificationSubject.sink;

  Stream<SettingsResponseState> _getSettings() async* {
    yield Loading();

    try {
      yield Success(
        settings: await getSettingsUC.getFuture(),
      );
    } catch (e) {}
  }

  Stream<SettingsResponseState> _changeOrientation() async* {
    try {
      final Success previousResponseState = _onNewStateSubject.value;

      if (!previousResponseState.settings.isLandscape) {
        await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      } else {
        await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp]);
      }

      final newSettings = Settings(
          isLandscape: !previousResponseState.settings.isLandscape,
          isMobileNetworkEnabled:
              previousResponseState.settings.isMobileNetworkEnabled,
          isNotificationOnMediaEnabled:
              previousResponseState.settings.isNotificationOnMediaEnabled);

      await changeSettingsUC.getFuture(
        params: ChangeSettingsUCParams(newSettings),
      );

      yield Success(
        settings: newSettings,
      );
    } catch (e) {
      yield Error();
    }
  }

  // todo: MUST make it in kotlin, dart do not support it
  Stream<SettingsResponseState> _changeNetworkSource() async* {
    final Success previousResponseState = _onNewStateSubject.value;
    final newSettings = Settings(
        isLandscape: previousResponseState.settings.isLandscape,
        isMobileNetworkEnabled:
            !previousResponseState.settings.isMobileNetworkEnabled,
        isNotificationOnMediaEnabled:
            previousResponseState.settings.isNotificationOnMediaEnabled);

    yield Success(
      settings: newSettings,
    );
  }

  // todo: create UC to allow notification
  Stream<SettingsResponseState> _allowNotification() async* {
    final Success previousResponseState = _onNewStateSubject.value;
    final newSettings = Settings(
        isLandscape: previousResponseState.settings.isLandscape,
        isMobileNetworkEnabled:
            previousResponseState.settings.isMobileNetworkEnabled,
        isNotificationOnMediaEnabled:
            !previousResponseState.settings.isNotificationOnMediaEnabled);

    yield Success(
      settings: newSettings,
    );
  }

  void dispose() {
    _onEnableNotificationSubject.close();
    _onEnableMobileNetworkSubject.close();
    _onChangeOrientationSubject.close();
    _onNewStateSubject.close();
  }
}
