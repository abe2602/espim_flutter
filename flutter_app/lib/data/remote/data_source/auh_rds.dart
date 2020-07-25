import 'package:dio/dio.dart';
import 'package:domain/exceptions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

//todo: Integrar com o server do Intermedia
class AuthRDS {
  const AuthRDS({
    @required this.dio,
    @required this.googleSignIn,
  })  : assert(dio != null),
        assert(googleSignIn != null);

  final Dio dio;
  final GoogleSignIn googleSignIn;

  Future<void> login() => googleSignIn.signIn().then((_) => null).catchError(
        (error) {
          if (error is PlatformException && error.code == 'network_error') {
            throw NoInternetException();
          } else {
            throw UserNotLoggedException();
          }
        },
      );

  Future<void> logout() =>
      googleSignIn.signOut().then((_) => null).catchError((error) {});
}
