import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:domain/exceptions.dart';
import 'package:domain/model/media_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
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

class InternetImage extends StatelessWidget {
  const InternetImage({
    @required this.url,
    this.width,
    this.height,
  }) : assert(url != null);

  final String url;
  final double width, height;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Center(
          child: Image.asset(
            'images/no_image.png',
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ),
        fit: BoxFit.scaleDown,
      );
}

class InternetVideoPlayer extends StatefulWidget {
  const InternetVideoPlayer({
    @required this.videoPlayerController,
    this.autoPlay = true,
  }) : assert(videoPlayerController != null);
  final VideoPlayerController videoPlayerController;
  final bool autoPlay;

  @override
  State<StatefulWidget> createState() =>
      VideoPlayerState(videoPlayerController: videoPlayerController);
}

class VideoPlayerState extends State<InternetVideoPlayer> {
  VideoPlayerState({
    @required this.videoPlayerController,
  });

  final VideoPlayerController videoPlayerController;
  ChewieController _controller;
  Chewie _videoPlayer;

  @override
  void initState() {
    super.initState();

    _controller = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: videoPlayerController.value.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: false,
    );

    _videoPlayer = Chewie(
      controller: _controller,
    );
  }

  @override
  Widget build(BuildContext context) => _videoPlayer;

  @override
  void dispose() {
    videoPlayerController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

void navigateToNextIntervention(
  BuildContext context,
  int nextPosition,
  int flowSize,
  int eventId,
  String type,
) {
  if (flowSize == nextPosition || nextPosition == 0) {
    Navigator.popUntil(
        context, ModalRoute.withName(RouteNameBuilder.accompaniment));
  } else {
    Navigator.of(context).pushNamed(
      RouteNameBuilder.interventionType(type, eventId, nextPosition, flowSize),
    );
  }
}

class SensemButton extends StatelessWidget {
  const SensemButton({
    @required this.onPressed,
    @required this.buttonText,
  });

  final Function onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) => FlatButton(
        onPressed: onPressed,
        color: SenSemColors.aquaGreen,
        disabledColor: SenSemColors.disabledLightGray,
        child: Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}

class InterventionBody extends StatefulWidget {
  const InterventionBody({
    @required this.statement,
    @required this.next,
    @required this.nextPage,
    @required this.nextInterventionType,
    @required this.eventId,
    @required this.flowSize,
    @required this.orderPosition,
    @required this.onPressed,
    this.child,
    this.mediaInformation,
  })  : assert(statement != null),
        assert(next != null),
        assert(nextPage != null),
        assert(nextInterventionType != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(orderPosition != null);
  final String statement, nextInterventionType;
  final List<MediaInformation> mediaInformation;
  final Widget child;
  final int eventId, flowSize, nextPage, next, orderPosition;
  final Function onPressed;

  @override
  State<StatefulWidget> createState() => InterventionBodyState();
}

class InterventionBodyState extends State<InterventionBody> {
  VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: UniqueKey(),
        onVisibilityChanged: (visibilityInfo) async {
          if (visibilityInfo.visibleFraction == 0.0) {
            await videoPlayerController?.pause();
          }
        },
        child: Column(
          children: [
//            Container(
//              alignment: Alignment.topLeft,
//              child: Text(
//                S
//                    .of(context)
//                    .task_flow_pages(widget.orderPosition, widget.flowSize),
//              ),
//            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.statement,
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
                  ...widget.mediaInformation?.map(
                    (media) {
                      if (media.mediaType == 'image') {
                        return InternetImage(
                          url: media.mediaUrl,
                        );
                      } else {
                        videoPlayerController =
                            VideoPlayerController.network(media.mediaUrl);
                        return InternetVideoPlayer(
                          videoPlayerController: videoPlayerController,
                          autoPlay: media.shouldAutoPlay,
                        );
                      }
                    },
                  ),
                  if (widget.child == null)
                    Container()
                  else
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: widget.child,
                    ),
                ],
              ),
            ),
            SensemButton(
              onPressed: widget.onPressed,
              buttonText: widget.next == widget.flowSize || widget.next == 0
                  ? S.of(context).finish
                  : S.of(context).next,
            ),
          ],
        ),
      );
}
