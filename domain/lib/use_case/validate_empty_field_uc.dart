import 'dart:async';

import '../exceptions.dart';
import 'use_case.dart';

class ValidateOpenQuestionTextUC
    extends UseCase<ValidateOpenQuestionTextUCParams, void> {
  @override
  Future<void> getRawFuture({ValidateOpenQuestionTextUCParams params}) {
    final completer = Completer();
    final fullName = params.text ?? '';

    if (fullName.isEmpty) {
      completer.completeError(EmptyFormFieldException());
      return completer.future;
    }
    completer.complete();

    return completer.future;
  }
}

class ValidateOpenQuestionTextUCParams {
  const ValidateOpenQuestionTextUCParams(this.text);

  final String text;
}
