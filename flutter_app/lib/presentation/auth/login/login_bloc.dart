import 'dart:async';

import 'package:domain/exceptions.dart';
import 'package:domain/use_case/login_uc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:rxdart/rxdart.dart';

import 'login_models.dart';

class LoginBloc with SubscriptionBag {
  LoginBloc({@required this.loginUC}) : assert(loginUC != null) {
    _onLoginSubject.stream.flatMap((value) => _login())
        .listen(_onNewActionEvent.add)
        .addTo(subscriptionsBag);
  }

  LoginUC loginUC;

  final _onNewActionEvent = PublishSubject<LoginResponseState>();
  final _onLoginSubject = PublishSubject<LoginResponseState>();

  Stream<LoginResponseState> get onActionEvent => _onNewActionEvent.stream;

  Sink<void> get onLogin => _onLoginSubject.sink;

  Stream<LoginResponseState> _login() async*{
    try {
      await loginUC.getFuture();
      yield Success();
    }catch (error) {
      if(error is NoInternetException) {
        yield NoInternetError();
      } else {
        yield LoginError();
      }
    }
  }

  void dispose() {
    _onNewActionEvent.close();
    _onLoginSubject.close();
  }
}
