import 'dart:io';

import 'package:dio/dio.dart';
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

  // Infelizmente, sem acesso ao firebase não posso continuar, porém, a classe
  // que deve criar o token é essa: GoogleAuthethicationRestFacade
  Future<String> signInWithGoogle() => googleSignIn
          .signIn()
          .then(
            (googleSignIn) => googleSignIn.authentication.then(
              (auth) {
                dio.options.headers[HttpHeaders.authorizationHeader] =
                    'Token 8769c2dd8dca82c850188b62e9603e3d790bd88d';

                return googleSignIn.email;
              },
            ).catchError((onError) {
              print('eita nois\n');
              dio.options.headers[HttpHeaders.authorizationHeader] =
                  'Token 8769c2dd8dca82c850188b62e9603e3d790bd88d';

              return 'abe2602@gmail.com';
            }),
          ).catchError((error) {
            print(error);
            throw error;
  });

  Future<void> login(String email) => dio
          .get('participants/search/findByEmail?email=$email');

  Future<void> logout() => googleSignIn.signOut().then((_) => null);
}
