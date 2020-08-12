import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:domain/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:video_player/video_player.dart';

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
    @required this.videoUrl,
    @required this.videoPlayerController,
  }) : assert(videoUrl != null);
  final VideoPlayerController videoPlayerController;
  final String videoUrl;

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
      autoPlay: true,
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
        context,
        ModalRoute.withName(
            RouteNameBuilder.accompaniment));
  } else {
    Navigator.of(context).pushNamed(
      RouteNameBuilder.interventionType(
          type, eventId, nextPosition, flowSize),
    );
  }
}
