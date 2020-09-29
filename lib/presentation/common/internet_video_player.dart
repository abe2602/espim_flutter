import 'package:chewie/chewie.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:video_player/video_player.dart';

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
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: BoxDecoration(
          border: Border.all(
            color: SenSemColors.primaryColor,
            width: 2,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Flexible(
            child: _videoPlayer,
          ),
        ),
      );

  @override
  void dispose() {
    videoPlayerController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
