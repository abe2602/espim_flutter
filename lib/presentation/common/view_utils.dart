import 'dart:async';
import 'dart:io';

import 'package:domain/exceptions.dart';
import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

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

String createLikertTypeResponse(int length, List<String> answerList) {
  var semanticDiffAnswerString = '';

  for (var i = 0; i < length; i++) {
    semanticDiffAnswerString += answerList[i];
    semanticDiffAnswerString += '_SEP_';
    semanticDiffAnswerString += answerList[i + 1];
  }

  return semanticDiffAnswerString;
}

class CameraFile extends StatelessWidget {
  const CameraFile({
    @required this.cameraFile,
    @required this.changeFileAction,
    @required this.fileWidget,
  }) : assert(cameraFile != null);

  final File cameraFile;
  final Function changeFileAction;
  final Widget fileWidget;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 18),
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                color: SenSemColors.lightGray2,
              ),
              fileWidget,
            ],
          ),
          FlatButton(
            onPressed: changeFileAction,
            color: SenSemColors.lightRoyalBlue,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              alignment: Alignment.bottomCenter,
              child: Text(
                S.of(context).change_file_label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
}
