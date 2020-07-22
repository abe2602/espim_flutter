import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class AuthRDS {
  const AuthRDS({
    @required this.dio,
  }) : assert(dio != null);

  final Dio dio;

  Future<bool> checkIsUserLogged() => Future.value(false);
}