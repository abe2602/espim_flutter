import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:domain/model/media_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/internet_image.dart';
import 'package:flutter_app/presentation/common/internet_video_player.dart';
import 'package:flutter_app/presentation/common/sensem_button.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  VideoPlayerController _videoPlayerController;

  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId('audio');
  bool _isAudioPlaying;
  IconData _buttonIcon;

  @override
  void initState() {
    _isAudioPlaying = true;
    _buttonIcon = Icons.pause_circle_filled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: UniqueKey(),
        onVisibilityChanged: (visibilityInfo) async {
          if (visibilityInfo.visibleFraction == 0.0) {
            await _videoPlayerController?.pause();
            await _assetsAudioPlayer.pause();
          }
        },
        child: Column(
          children: [
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
                      } else if (media.mediaType == 'video') {
                        _videoPlayerController =
                            VideoPlayerController.network(media.mediaUrl);
                        return InternetVideoPlayer(
                          videoPlayerController: _videoPlayerController,
                          autoPlay: media.shouldAutoPlay,
                        );
                      } else {
                        final myAudio = Audio.network(
                          media.mediaUrl,
                        );
                        _assetsAudioPlayer.open(
                          myAudio,
                          autoStart: media.shouldAutoPlay,
                          showNotification: false,
                          playInBackground: PlayInBackground.enabled,
                          audioFocusStrategy: const AudioFocusStrategy.request(
                              resumeAfterInterruption: true,
                              resumeOthersPlayersAfterDone: true),
                        );

                        return InkWell(
                          onTap: () async {
                            if (_isAudioPlaying) {
                              await _assetsAudioPlayer.pause();

                              setState(() {
                                _buttonIcon = Icons.pause_circle_filled;
                              });

                              _isAudioPlaying = !_isAudioPlaying;
                            } else {
                              await _assetsAudioPlayer.play();

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
              buttonText:
                  widget.next == 0 ? S.of(context).finish : S.of(context).next,
            ),
          ],
        ),
      );
}
