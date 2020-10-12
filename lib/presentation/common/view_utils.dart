import 'dart:async';

import 'package:domain/exceptions.dart';
import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:permission_handler/permission_handler.dart';

extension StringToColor on String {
  Color toColor() {
    if (this == 'none') {
      return SenSemColors.primaryColor;
    } else {
      return Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
    }
  }
}

//Sempre que o foco é perdido, da um trigger no listener
extension FocusNodeViewUtils on FocusNode {
  void addFocusLostListener(VoidCallback listener) {
    addListener(
      () {
        if (!hasFocus) {
          listener();
        }
      },
    );
  }
}

extension FutureViewUtils on Future<void> {
  Future<void> addStatusToSink(Sink<InputStatusVM> sink) => then(
        (_) {
          sink.add(InputStatusVM.valid);
          return null;
        },
      ).catchError(
        (error) {
          sink.add(error is EmptyFormFieldException
              ? InputStatusVM.empty
              : InputStatusVM.invalid);

          throw error;
        },
      );
}

void navigateToNextIntervention(
  BuildContext context,
  int nextPosition,
  int flowSize,
  int eventId,
  InterventionType type,
  EventResult eventResult,
) {
  if (nextPosition == 0) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  } else {
    Navigator.of(context).pushNamed(
      RouteNameBuilder.interventionType(type, eventId, nextPosition, flowSize),
      arguments: eventResult,
    );
  }
}

extension DialogUtils on Widget {
  Future<T> showAsDialog<T>(BuildContext context,
          {bool isMaterialDismissible = true}) async =>
      showDialog(
        context: context,
        builder: (context) => this,
        barrierDismissible: isMaterialDismissible,
      );
}

String createLikertTypeResponse(int length, List<String> answerList) {
  var semanticDiffAnswerString = '';

  for (var i = 0; i < length; i++) {
    semanticDiffAnswerString += answerList[i];
    semanticDiffAnswerString += '_SEP_';
    semanticDiffAnswerString += answerList[i + 1];
  }

  return semanticDiffAnswerString;
}

Future<PermissionStatus> askCameraPermission() async =>
    Permission.camera.request();

Future<PermissionStatus> askMicrophonePermission() async =>
    Permission.microphone.request();
