import 'package:domain/use_case/login_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/sensem_action_listener.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/auth/login/login_models.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: SenSemColors.primaryColor,
        body: SensemActionListener(
          actionStream: widget.bloc.onActionEvent,
          onReceived: (event) {
            if(event is LoginError) {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text(
                    S.of(context).non_blocking_generic_error_message,
                  ),
                ),
              );
            } else if(event is NoInternetError) {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text(
                  S.of(context).non_blocking_no_internet_error_message,
                  ),
                ),
              );
            }else if(event is Success) {
              Navigator.pushReplacementNamed(context, 'accompaniment');
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
                    onPressed: ()  {
                      widget.bloc.onLogin.add(null);
//                      try {
//                        var userCredentials = await googleSignIn.signIn();
//                        print(userCredentials.toString());
//                        setState(() {});
//                      } catch (error) {
//                        print(error.toString());
//                      }
                      //Navigator.of(context).pushReplacementNamed('accompaniment');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('images/google_icon.png'),
                        const Text('LOGIN COM GOOGLE!'),
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
