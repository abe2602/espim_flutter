import 'dart:io';

import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/model/media_information.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/upload_file_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/media_intervention_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../intervention_models.dart';
import 'media_intervention_bloc.dart';

class MediaInterventionPage extends StatefulWidget {
  const MediaInterventionPage({
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
          builder: (context, bloc, _) => MediaInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
            eventResult: eventResult,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => MediaInterventionPageState();
}

class MediaInterventionPageState extends State<MediaInterventionPage> {
  final _startTime = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: SensemActionListener<InterventionResponseState>(
          onReceived: (receivedEvent) async {
            if (receivedEvent is UploadLoading) {
              await showDialog(
                context: context,
                child: AlertDialog(
                  title: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          S.of(context).wait_please_label,
                        ),
                      ),
                      LoadingIndicator(),
                    ],
                  ),
                ),
              );
            } else if (receivedEvent is Success) {
              Navigator.pop(context);
              if (receivedEvent.nextPage == 0) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                widget.eventResult.interventionResultsList.add(
                  InterventionResult(
                    interventionType: receivedEvent.intervention.type,
                    startTime: _startTime,
                    endTime: DateTime.now().millisecondsSinceEpoch,
                    interventionId: receivedEvent.intervention.interventionId,
                    answer: receivedEvent.mediaUrl,
                  ),
                );

                widget.eventResult.interventionsIds
                    .add(receivedEvent.intervention.interventionId);

                await Navigator.of(context).pushNamed(
                  RouteNameBuilder.interventionType(
                      receivedEvent.nextInterventionType,
                      widget.eventId,
                      receivedEvent.nextPage,
                      widget.flowSize),
                  arguments: widget.eventResult,
                );
              }
            }
          },
          actionStream: widget.bloc.onActionEventStream,
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: widget.bloc.onNewState,
              builder: (context, snapshot) => AsyncSnapshotResponseView<Loading,
                  Error, MediaInterventionSuccess>(
                snapshot: snapshot,
                successWidgetBuilder: (successState) => Container(
                  margin: const EdgeInsets.all(15),
                  child: successState.mediaType == 'video'
                      ? _RecordVideoView(
                          statement: successState.intervention.statement,
                          mediaInformation:
                              successState.intervention.mediaInformation,
                          nextPage: successState.nextPage,
                          nextIntervention: successState.intervention.next,
                          nextInterventionType:
                              successState.nextInterventionType,
                          eventId: widget.eventId,
                          flowSize: widget.flowSize,
                          orderPosition:
                              successState.intervention.orderPosition,
                          bloc: widget.bloc,
                        )
                      : successState.mediaType == 'image'
                          ? _TakePictureView(
                              statement: successState.intervention.statement,
                              mediaInformation:
                                  successState.intervention.mediaInformation,
                              nextPage: successState.nextPage,
                              nextIntervention: successState.intervention.next,
                              nextInterventionType:
                                  successState.nextInterventionType,
                              eventId: widget.eventId,
                              flowSize: widget.flowSize,
                              orderPosition:
                                  successState.intervention.orderPosition,
                              bloc: widget.bloc,
                            )
                          : _RecordAudioView(
                              statement: successState.intervention.statement,
                              mediaInformation:
                                  successState.intervention.mediaInformation,
                              nextPage: successState.nextPage,
                              nextIntervention: successState.intervention.next,
                              nextInterventionType:
                                  successState.nextInterventionType,
                              eventId: widget.eventId,
                              flowSize: widget.flowSize,
                              orderPosition:
                                  successState.intervention.orderPosition,
                              bloc: widget.bloc,
                            ),
                ),
                errorWidgetBuilder: (errorState) => Text(
                  errorState.toString(),
                ),
              ),
            ),
          ),
        ),
      );
}

class _CameraFile extends StatelessWidget {
  const _CameraFile({
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
  })  : assert(statement != null),
        assert(nextIntervention != null),
        assert(nextPage != null),
        assert(nextInterventionType != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(orderPosition != null),
        assert(mediaInformation != null),
        assert(bloc != null);

  final String statement, nextInterventionType;
  final List<MediaInformation> mediaInformation;
  final MediaInterventionBloc bloc;
  final int eventId, flowSize, nextPage, nextIntervention, orderPosition;

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
        onPressed: _cameraFile == null
            ? null
            : () async {
                widget.bloc.onActionEventSink.add(_cameraFile);
              },
        child: Container(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  takePicture(ImageSource.camera);
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
                    : _CameraFile(
                        cameraFile: _cameraFile,
                        changeFileAction: () {
                          takePicture(ImageSource.camera);
                        },
                        fileWidget: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width / 2,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.file(_cameraFile),
                              ),
                            ),
                            Text(
                              _cameraFile.path.split('/').last,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
}

// RecordVideo Widget
class _RecordVideoView extends StatefulWidget {
  const _RecordVideoView({
    @required this.statement,
    @required this.nextIntervention,
    @required this.nextPage,
    @required this.nextInterventionType,
    @required this.eventId,
    @required this.flowSize,
    @required this.orderPosition,
    @required this.mediaInformation,
    @required this.bloc,
  })  : assert(statement != null),
        assert(nextIntervention != null),
        assert(nextPage != null),
        assert(nextInterventionType != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(orderPosition != null),
        assert(mediaInformation != null),
        assert(bloc != null);

  final String statement, nextInterventionType;
  final List<MediaInformation> mediaInformation;
  final MediaInterventionBloc bloc;
  final int eventId, flowSize, nextPage, nextIntervention, orderPosition;

  @override
  State<StatefulWidget> createState() => _RecordVideoViewState();
}

class _RecordVideoViewState extends State<_RecordVideoView> {
  File _videoFile;
  VideoPlayerController videoPlayerController;

  Future<void> _recordVideo(ImageSource imageSource) async {
    try {
      final pickedFile = await ImagePicker().getVideo(source: imageSource);

      setState(() {
        _videoFile = File(pickedFile.path);
        videoPlayerController = VideoPlayerController.file(_videoFile)
          ..initialize();
      });
    } catch (e) {
      print(e);
    }
  }

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
        onPressed: _videoFile == null
            ? null
            : () async {
                widget.bloc.onActionEventSink.add(_videoFile);
                await videoPlayerController?.pause();
              },
        child: Container(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await _recordVideo(ImageSource.camera);
                },
                child: _videoFile == null
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
                    : _CameraFile(
                        cameraFile: _videoFile,
                        changeFileAction: () =>
                            _recordVideo(ImageSource.camera),
                        fileWidget: InternetVideoPlayer(
                          videoPlayerController: videoPlayerController,
                          autoPlay: false,
                        ),
                      ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }
}

// RecordVideo Widget
class _RecordAudioView extends StatefulWidget {
  const _RecordAudioView({
    @required this.statement,
    @required this.nextIntervention,
    @required this.nextPage,
    @required this.nextInterventionType,
    @required this.eventId,
    @required this.flowSize,
    @required this.orderPosition,
    @required this.mediaInformation,
    @required this.bloc,
  })  : assert(statement != null),
        assert(nextIntervention != null),
        assert(nextPage != null),
        assert(nextInterventionType != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(orderPosition != null),
        assert(mediaInformation != null),
        assert(bloc != null);

  final String statement, nextInterventionType;
  final List<MediaInformation> mediaInformation;
  final MediaInterventionBloc bloc;
  final int eventId, flowSize, nextPage, nextIntervention, orderPosition;

  @override
  State<StatefulWidget> createState() => _RecordAudioViewState();
}

class _RecordAudioViewState extends State<_RecordAudioView> {
  File _audioFile;

  Future<void> _recordAudio() async {
    try {} catch (e) {
      print(e);
    }
  }

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
        onPressed: _audioFile == null ? null : () async {},
        child: Container(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await _recordAudio();
                },
                child: _audioFile == null ? Center(
                  child: FlatButton(
                    onPressed: (){},
                    child: Text('HOLD TO RECORD', textAlign: TextAlign.center,),
                  ),
                ) : Container(),
              ),
            ],
          ),
        ),
      );
}
