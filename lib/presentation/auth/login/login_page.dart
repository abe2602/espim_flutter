import 'package:domain/use_case/login_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/auth/login/login_models.dart';
import 'package:flutter_app/presentation/common/alert_dialog/generic_error_alert_dialog.dart';
import 'package:flutter_app/presentation/common/alert_dialog/no_connection_alert_dialog.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:provider/provider.dart';

import 'login_bloc.dart';

//todo: criar dialogs de erros mais bonitinhos!
class LoginPage extends StatefulWidget {
  const LoginPage({@required this.bloc}) : assert(bloc != null);
  final LoginBloc bloc;

  static Widget create() => ProxyProvider<LoginUC, LoginBloc>(
        update: (context, loginUC, _) => LoginBloc(loginUC: loginUC),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<LoginBloc>(
          builder: (context, bloc, _) => LoginPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: SenSemColors.primaryColor,
        body: SensemActionListener(
          actionStream: widget.bloc.onActionEvent,
          onReceived: (event) {
            if (event is LoginError) {
              GenericErrorAlertDialog().showAsDialog(context);
            }

            if (event is NoConnectionError) {
              NoInternetAlertDialog().showAsDialog(context);
            }

            if (event is Success) {
              Navigator.of(context, rootNavigator: false)
                  .pushNamedAndRemoveUntil(
                      RouteNameBuilder.accompanimentPage(), (_) => false);
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('images/img_splash.png'),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      widget.bloc.onLogin.add(null);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('images/google_icon.png'),
                        Text(S.of(context).google_sign_in),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
