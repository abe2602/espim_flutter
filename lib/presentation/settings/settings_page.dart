import 'package:domain/use_case/change_settings_uc.dart';
import 'package:domain/use_case/get_settings_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/settings/settings_bloc.dart';
import 'package:flutter_app/presentation/settings/settings_models.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({@required this.bloc}) : assert(bloc != null);

  static Widget create() =>
      ProxyProvider2<GetSettingsUC, ChangeSettingsUC, SettingsBloc>(
        update: (context, getSettingsUC, changeSettingsUC, _) => SettingsBloc(
          getSettingsUC: getSettingsUC,
          changeSettingsUC: changeSettingsUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<SettingsBloc>(
          builder: (context, bloc, _) => SettingsPage(
            bloc: bloc,
          ),
        ),
      );

  final SettingsBloc bloc;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: SenSemColors.primaryColor,
          title: Text(
            S.of(context).settings_label,
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: bloc.onNewState,
            builder: (context, snapshot) =>
                AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              successWidgetBuilder: (successState) => Container(
                height: MediaQuery.of(context).size.height + 40,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingOption(
                      title: S.of(context).landscape_layout_mode_title_label,
                      subTitle:
                          S.of(context).landscape_layout_mode_subtitle_label,
                      child: Checkbox(
                        value: successState.settings.isLandscape,
                        onChanged: (_) {
                          bloc.onChangeOrientationSink.add(null);
                        },
                      ),
                    ),
                    SettingOption(
                      title: S.of(context).enable_mobile_network_title_label,
                      subTitle:
                          S.of(context).enable_mobile_network_subtitle_label,
                      child: Switch(
                        value: successState.settings.isMobileNetworkEnabled,
                        onChanged: (_) {
                          bloc.onEnableMobileNetworkSink.add(null);
                        },
                      ),
                    ),
                    SettingOption(
                      title: S.of(context).enable_notifications_title_label,
                      subTitle:
                          S.of(context).enable_notifications_subtitle_label,
                      child: Switch(
                        value:
                            successState.settings.isNotificationOnMediaEnabled,
                        onChanged: (_) {
                          bloc.onEnableNotificationSink.add(null);
                        },
                      ),
                    ),
                    SettingOption(
                      title: S.of(context).delete_medias_title_label,
                      subTitle: S.of(context).delete_medias_subtitle_label,
                    ),
                    SettingOption(
                      title: S.of(context).home_address_title_label,
                      subTitle: S
                          .of(context)
                          .home_address_subtitle_label('Saint Charles'),
                    ),
                  ],
                ),
              ),
              errorWidgetBuilder: (errorState) => Text(
                errorState.toString(),
              ),
            ),
          ),
        ),
      );
}

class SettingOption extends StatefulWidget {
  const SettingOption({
    @required this.title,
    @required this.subTitle,
    this.child,
  })  : assert(title != null),
        assert(subTitle != null);

  final String title;
  final String subTitle;
  final Widget child;

  @override
  State<StatefulWidget> createState() => SettingOptionState();
}

class SettingOptionState extends State<SettingOption> {
  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            widget.subTitle,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: SenSemColors.mediumGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.child ?? Container(),
              ],
            ),
            const Divider(),
          ],
        ),
      );
}
