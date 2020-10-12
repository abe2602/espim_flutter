import 'dart:io';

import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_type.dart';
import 'package:domain/model/media_information.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/upload_file_uc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/action_dialog/permission_permanently_denied_action_dialog.dart';
import 'package:flutter_app/presentation/common/alert_dialog/permission_denied_alert_dialog.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/camera_file.dart';
import 'package:flutter_app/presentation/common/intervention_body.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/common/media_intervention_bloc.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/common/media_intervention_body.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/common/media_intervention_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../intervention_models.dart';

class TakePictureInterventionPage extends StatelessWidget {
  TakePictureInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null);

  final EventResult eventResult;
  final MediaInterventionBloc bloc;
  final int eventId;
  final int flowSize;
  final int _startTime = DateTime.now().millisecondsSinceEpoch;

  static Widget create(int eventId, int orderPosition, int flowSize,
          EventResult eventResult) =>
      ProxyProvider2<GetInterventionUC, UploadFileUC, MediaInterventionBloc>(
        update: (context, getInterventionUC, uploadFileUC, _) =>
            MediaInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
          uploadFileUC: uploadFileUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<MediaInterventionBloc>(
          builder: (context, bloc, _) => TakePictureInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
            eventResult: eventResult,
          ),
        ),
      );

  @override
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: MediaInterventionBody(
          bloc: bloc,
          eventId: eventId,
          flowSize: flowSize,
          eventResult: eventResult,
          startTime: _startTime,
          child: StreamBuilder(
            stream: bloc.onNewState,
            builder: (context, snapshot) => AsyncSnapshotResponseView<Loading,
                Error, MediaInterventionSuccess>(
              snapshot: snapshot,
              successWidgetBuilder: (successState) => _TakePictureView(
                statement: successState.intervention.statement,
                mediaInformation: successState.intervention.mediaInformation,
                nextPage: successState.nextPage,
                nextIntervention: successState.intervention.next,
                nextInterventionType: successState.nextInterventionType,
                eventId: eventId,
                flowSize: flowSize,
                orderPosition: successState.intervention.orderPosition,
                isObligatory: successState.intervention.isObligatory,
                bloc: bloc,
              ),
              errorWidgetBuilder: (errorState) => Text(
                errorState.toString(),
              ),
            ),
          ),
        ),
      );
}

// TakePicture Widget
class _TakePictureView extends StatefulWidget {
  const _TakePictureView({
    @required this.statement,
    @required this.nextIntervention,
    @required this.nextPage,
    @required this.nextInterventionType,
    @required this.eventId,
    @required this.flowSize,
    @required this.orderPosition,
    @required this.mediaInformation,
    @required this.bloc,
    @required this.isObligatory,
  })  : assert(statement != null),
        assert(nextIntervention != null),
        assert(nextPage != null),
        assert(nextInterventionType != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(orderPosition != null),
        assert(mediaInformation != null),
        assert(isObligatory != null),
        assert(bloc != null);

  final String statement;
  final InterventionType nextInterventionType;
  final List<MediaInformation> mediaInformation;
  final MediaInterventionBloc bloc;
  final int eventId, flowSize, nextPage, nextIntervention, orderPosition;
  final bool isObligatory;

  @override
  State<StatefulWidget> createState() => _TakePictureViewState();
}

class _TakePictureViewState extends State<_TakePictureView> {
  File _cameraFile;

  Future<void> takePicture(ImageSource imageSource) async {
    try {
      final pickedFile = await ImagePicker().getImage(source: imageSource);

      setState(() {
        _cameraFile = File(pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  void _onPressed() => widget.bloc.onActionEventSink.add(_cameraFile);

  @override
  Widget build(BuildContext context) => InterventionBody(
        statement: widget.statement,
        mediaInformation: widget.mediaInformation,
        nextPage: widget.nextPage,
        next: widget.nextIntervention,
        nextInterventionType: widget.nextInterventionType,
        eventId: widget.eventId,
        flowSize: widget.flowSize,
        orderPosition: widget.orderPosition,
        onPressed: widget.isObligatory
            ? _cameraFile == null ? null : _onPressed
            : _onPressed,
        child: Container(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final status = await askCameraPermission();

                  if (status == PermissionStatus.granted) {
                    await takePicture(ImageSource.camera);
                  } else if (status == PermissionStatus.denied) {
                    await PermissionDeniedAlertDialog().showAsDialog(context);
                  } else {
                    await PermissionPermanentlyDeniedActionDialog()
                        .showAsDialog(context);
                  }
                },
                child: _cameraFile == null
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            color: SenSemColors.lightGray2,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Image.asset('images/file.png'),
                              ),
                              Text(
                                S.of(context).upload_files_action_label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: SenSemColors.mediumGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : DottedBorder(
                        color: SenSemColors.primaryColor,
                        strokeWidth: 1,
                        child: CameraFile(
                          cameraFile: _cameraFile,
                          changeFileAction: () {
                            takePicture(ImageSource.camera);
                          },
                          fileWidget: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Image.file(
                                  _cameraFile,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                _cameraFile.path.split('/').last,
                                overflow: TextOverflow.fade,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
}
