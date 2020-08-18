import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/data/remote/model/user_rm.dart';

class UserRDS {
  const UserRDS({
    @required this.dio,
  }) : assert(dio != null);

  final Dio dio;

  Future<UserRM> getLoggedUser() =>
      Future.value(
          const UserRM(id: 1, name: 'Bruno'),
      );
}