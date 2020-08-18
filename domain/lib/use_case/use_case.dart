import 'package:meta/meta.dart';

import '../exceptions.dart';

abstract class UseCase<Params, Response> {
  @protected
  Future<Response> getRawFuture({Params params});

  Future<Response> getFuture({Params params}) =>
      getRawFuture(params: params).catchError(
            (error) {
          if (error is! SensemException) {
            throw UnexpectedException();
          } else {
            throw error;
          }
        },
      );
}