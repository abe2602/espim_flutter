import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:flutter_app/presentation/intervention/empty_intervention/empty_intervention_bloc.dart';
import 'package:provider/provider.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:video_player/video_player.dart';

import '../intervention_models.dart';
import 'empty_intervention_models.dart';

class EmptyInterventionPage extends StatefulWidget {
  const EmptyInterventionPage({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null);
  final EmptyInterventionBloc bloc;
  final int eventId;
  final int flowSize;

  static Widget create(int eventId, int orderPosition, int flowSize) =>
      ProxyProvider<GetInterventionUC, EmptyInterventionBloc>(
        update: (context, getInterventionUC, _) => EmptyInterventionBloc(
          eventId: eventId,
          flowSize: flowSize,
          orderPosition: orderPosition,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<EmptyInterventionBloc>(
          builder: (context, bloc, _) => EmptyInterventionPage(
            bloc: bloc,
            eventId: eventId,
            flowSize: flowSize,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => EmptyInterventionPageState();
}

class EmptyInterventionPageState extends State<EmptyInterventionPage> {
  InternetVideoPlayer videoPlayer;
  VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              right: 15,
              left: 15,
            ),
            child: StreamBuilder(
              stream: widget.bloc.onNewState,
              builder: (context, snapshot) => AsyncSnapshotResponseView<Loading,
                  Error, EmptyInterventionSuccess>(
                snapshot: snapshot,
                successWidgetBuilder: (successState) => Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 15),
                      child: Text('Tarefa x de x'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: Text(
                        successState.intervention.statement,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          ...successState.intervention.mediaInformation.map(
                            (media) {
                              if (media.mediaType == 'image') {
                                return InternetImage(
                                  url: media.mediaUrl,
                                );
                              } else {
                                videoPlayerController =
                                    VideoPlayerController.network(
                                        media.mediaUrl);
                                return videoPlayer = InternetVideoPlayer(
                                  videoPlayerController: videoPlayerController,
                                  autoPlay: media.shouldAutoPlay,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SensemButton(
                      onPressed: () async {
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
                errorWidgetBuilder: (errorState) => Text('deu ruim na view'),
              ),
            ),
          ),
        ),
      );
}
