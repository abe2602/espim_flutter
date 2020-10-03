import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/model/media_information.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/upload_file_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/iconed_text.dart';
import 'package:flutter_app/presentation/common/internet_video_player.dart';
import 'package:flutter_app/presentation/common/intervention_body.dart';
import 'package:flutter_app/presentation/common/loading_indicator.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/media_intervention_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
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
                        nextInterventionType: successState.nextInterventionType,
                        eventId: widget.eventId,
                        flowSize: widget.flowSize,
                        orderPosition: successState.intervention.orderPosition,
                        isObligatory: successState.intervention.isObligatory,
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
                            isObligatory:
                                successState.intervention.isObligatory,
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
                            isObligatory:
                                successState.intervention.isObligatory,
                            bloc: widget.bloc,
                          ),
              ),
              errorWidgetBuilder: (errorState) => Text(
                errorState.toString(),
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

  final String statement, nextInterventionType;
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

  final String statement, nextInterventionType;
  final List<MediaInformation> mediaInformation;
  final MediaInterventionBloc bloc;
  final int eventId, flowSize, nextPage, nextIntervention, orderPosition;
  final bool isObligatory;

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

  Future<void> _onPressed() async {
    widget.bloc.onActionEventSink.add(_videoFile);
    await videoPlayerController?.pause();
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
        onPressed: widget.isObligatory
            ? _videoFile == null
                ? null
                : () async {
                    await _onPressed();
                  }
            : () async {
                await _onPressed();
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

// https://pub.dev/packages/flutter_audio_recorder
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

  final String statement, nextInterventionType;
  final List<MediaInformation> mediaInformation;
  final MediaInterventionBloc bloc;
  final int eventId, flowSize, nextPage, nextIntervention, orderPosition;
  final bool isObligatory;

  @override
  State<StatefulWidget> createState() => _RecordAudioViewState();
}

class _RecordAudioViewState extends State<_RecordAudioView> {
  String _recordFilePath;
  bool _isComplete = false;
  bool _isAudioPlaying;
  IconData _buttonIcon;
  AudioPlayer audioPlayer;
  File _audioFile;

  @override
  void initState() {
    _isAudioPlaying = true;
    _buttonIcon = Icons.pause_circle_filled;
    super.initState();
  }

  void _onPressed() => widget.bloc.onActionEventSink
      .add(_recordFilePath == null ? null : File(_recordFilePath));

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
            ? _recordFilePath == null ? null : _onPressed
            : _onPressed,
        child: Column(
          children: [
            if (_isComplete)
              InkWell(
                onTap: () async {
                  if (_isAudioPlaying) {
                    _playAudio();

                    setState(() {
                      _buttonIcon = Icons.pause_circle_filled;
                    });

                    _isAudioPlaying = !_isAudioPlaying;
                  } else {
                    _pauseAudio();
                    setState(() {
                      _buttonIcon = Icons.play_circle_filled;
                    });

                    _isAudioPlaying = !_isAudioPlaying;
                  }
                },
                child: StreamBuilder<Duration>(
                  stream: audioPlayer?.onAudioPositionChanged,
                  builder: (_, snapshot) => Row(
                    children: [
                      Icon(
                        _buttonIcon,
                        color: SenSemColors.primaryColor,
                        size: 40,
                      ),
                      Text(
                        snapshot.data
                                ?.toString()
                                ?.substring(2, 7)
                                ?.replaceAll('.', ':') ??
                            '',
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(),
            GestureDetector(
              onLongPressStart: (_) {
                _startRecording();
              },
              onLongPressEnd: (_) {
                _stopRecording();
              },
              child: Center(
                child: FlatButton(
                  color: SenSemColors.primaryColor,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconedText(
                    icon: Icons.mic,
                    text: S.of(context).record_audio_label,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Future<bool> _checkPermission() async {
    final permissionHashMap = await [
      Permission.microphone,
    ].request();

    return permissionHashMap[Permission.microphone] == PermissionStatus.granted;
  }

  Future<void> _startRecording() async {
    if (await _checkPermission()) {
      _recordFilePath = await _getFilePath();
      _isComplete = false;
      RecordMp3.instance.start(_recordFilePath, (type) {
        setState(() {});
      });
    } else {
      // todo: fazer algo
    }
  }

  void _stopRecording() {
    final hasStopped = RecordMp3.instance.stop();
    if (hasStopped) {
      _isComplete = true;
      setState(() {});
    }
  }

  void _playAudio() {
    if (_recordFilePath != null && File(_recordFilePath).existsSync()) {
      audioPlayer ??= AudioPlayer();
      audioPlayer.play(_recordFilePath, isLocal: true);
    }
  }

  void _pauseAudio() {
    audioPlayer?.pause();
  }

  Future<String> _getFilePath() async {
    final storageDirectory = await getApplicationDocumentsDirectory();
    final pathDirectory = '${storageDirectory.path}/record';
    final directory = Directory(pathDirectory);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return "$pathDirectory${"/recorded_audio.mp3"}";
  }
}

class _AudioPlayerView extends StatefulWidget {
  const _AudioPlayerView({
    this.audioFilePath,
    this.playAudioFunction,
    this.pauseAudioFunction,
  });

  final String audioFilePath;
  final Function playAudioFunction;
  final Function pauseAudioFunction;

  @override
  State<StatefulWidget> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<_AudioPlayerView> {
  bool _isAudioPlaying;
  IconData _buttonIcon;

  @override
  void initState() {
    _isAudioPlaying = true;
    _buttonIcon = Icons.pause_circle_filled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async {
          if (_isAudioPlaying) {
            widget.pauseAudioFunction();

            setState(() {
              _buttonIcon = Icons.pause_circle_filled;
            });

            _isAudioPlaying = !_isAudioPlaying;
          } else {
            widget.playAudioFunction();

            setState(() {
              _buttonIcon = Icons.play_circle_filled;
            });

            _isAudioPlaying = !_isAudioPlaying;
          }
        },
        child: Icon(
          _buttonIcon,
          color: SenSemColors.primaryColor,
          size: 40,
        ),
      );
}
