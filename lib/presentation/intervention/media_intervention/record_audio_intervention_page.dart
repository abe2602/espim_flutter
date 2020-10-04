import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_type.dart';
import 'package:domain/model/media_information.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/upload_file_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/iconed_text.dart';
import 'package:flutter_app/presentation/common/intervention_body.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/common/media_intervention_bloc.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/common/media_intervention_body.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/common/media_intervention_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';

import '../intervention_models.dart';

class RecordAudioInterventionPage extends StatelessWidget {
  RecordAudioInterventionPage({
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
          builder: (context, bloc, _) => RecordAudioInterventionPage(
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
              successWidgetBuilder: (successState) => _RecordAudioView(
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

  final String statement;
  final InterventionType nextInterventionType;
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
