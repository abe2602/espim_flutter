import 'dart:io';

import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
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
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null);

  final MediaInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize) =>
      ProxyProvider<GetInterventionUC, MediaInterventionBloc>(
        update: (context, getInterventionUC, _) => MediaInterventionBloc(
          eventId: eventId,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<MediaInterventionBloc>(
          builder: (context, bloc, _) => MediaInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => MediaInterventionPageState();
}

class MediaInterventionPageState extends State<MediaInterventionPage> {
  File _cameraFile;
  VideoPlayerController videoPlayerController;

  Future<void> captureMedia(ImageSource imageSource, String mediaType) async {
    try {
      final pickedFile = mediaType == 'video'
          ? await ImagePicker().getVideo(source: imageSource)
          : await ImagePicker().getImage(source: imageSource);

      setState(() {
        _cameraFile = File(pickedFile.path);

        if (mediaType == 'video') {
          videoPlayerController = VideoPlayerController.file(_cameraFile)
            ..initialize();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: widget.bloc.onNewState,
            builder: (context, snapshot) => AsyncSnapshotResponseView<Loading,
                Error, MediaInterventionSuccess>(
              snapshot: snapshot,
              successWidgetBuilder: (successState) => Container(
                margin: const EdgeInsets.all(15),
               // height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      transform: Matrix4.translationValues(0, -10, 0),
                      child: Text('Tarefa x de x'),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0, 0, 0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              successState.intervention.statement ??
                                  S.of(context).upload_files,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              captureMedia(ImageSource.camera, 'video');
                            },
                            child: _cameraFile == null
                                ? Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 18),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: SenSemColors.lightGray2,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15),
                                            child:
                                                Image.asset('images/file.png'),
                                          ),
                                          Text(
                                            S
                                                .of(context)
                                                .upload_files_action_label,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: SenSemColors.mediumGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : CameraFile(
                                    cameraFile: _cameraFile,
                                    changeFileAction: () {
                                      captureMedia(ImageSource.camera, 'video');
                                    },
                                    fileWidget: successState.mediaType !=
                                            'video'
                                        ? InternetVideoPlayer(
                                            videoPlayerController:
                                                videoPlayerController,
                                            autoPlay: false,
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child:
                                                      Image.file(_cameraFile),
                                                ),
                                              ),
                                              Text(
                                                _cameraFile.path
                                                    .split('/')
                                                    .last,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ],
                                          ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SensemButton(
                      onPressed: _cameraFile == null
                          ? null
                          : () async {
                              await videoPlayerController?.pause();

                              if (successState.intervention.next ==
                                      successState.intervention.orderPosition ||
                                  successState.nextPage == 0) {
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        RouteNameBuilder.accompaniment));
                              } else {
                                await Navigator.of(context).pushNamed(
                                  RouteNameBuilder.interventionType(
                                      successState.nextInterventionType,
                                      widget.eventId,
                                      successState.nextPage,
                                      widget.flowSize),
                                );
                              }
                            },
                      buttonText: S.of(context).next,
                    ),
                  ],
                ),
              ),
              errorWidgetBuilder: (errorState) => Text(
                errorState.toString(),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }
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
