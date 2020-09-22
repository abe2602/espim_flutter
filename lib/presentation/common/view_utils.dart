import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:domain/exceptions.dart';
import 'package:domain/model/event_result.dart';
import 'package:domain/model/media_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/custom_slider.dart';
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

extension StringToColor on String {
  Color toColor() => Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
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

void navigateToNextIntervention(
  BuildContext context,
  int nextPosition,
  int flowSize,
  int eventId,
  String type,
  EventResult eventResult,
) {
  if (nextPosition == 0) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  } else {
    Navigator.of(context).pushNamed(
      RouteNameBuilder.interventionType(type, eventId, nextPosition, flowSize),
      arguments: eventResult,
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

class LikertCard extends StatefulWidget {
  const LikertCard({
    @required this.likertScale,
    @required this.index,
    @required this.likertAnswer,
    @required this.shouldAlwaysDisplayValueIndicator,
  })  : assert(likertScale != null),
        assert(index != null),
        assert(likertAnswer != null),
        assert(shouldAlwaysDisplayValueIndicator != null);

  final List<String> likertScale;
  final int index;
  final List<String> likertAnswer;
  final bool shouldAlwaysDisplayValueIndicator;

  @override
  State<StatefulWidget> createState() => LikertCardState();
}

class LikertCardState extends State<LikertCard> {
  double _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = 0.0;
  }

  @override
  Widget build(BuildContext context) => Container(
        color: SenSemColors.accentLightGray,
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: SenSemColors.lightGray,
                inactiveTrackColor: SenSemColors.lightGray,
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                thumbColor: SenSemColors.windowBlue,
                overlayColor: SenSemColors.primaryColor.withAlpha(32),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
                tickMarkShape:
                    const RoundSliderTickMarkShape(tickMarkRadius: 6),
                activeTickMarkColor: SenSemColors.lightGray,
                inactiveTickMarkColor: SenSemColors.lightGray,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: SenSemColors.windowBlue,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: CustomSlider(
                shouldAlwaysDisplayValueIndicator:
                    widget.shouldAlwaysDisplayValueIndicator,
                value: _selectedOption,
                min: 0,
                max: widget.likertScale.length.toDouble() - 1,
                divisions: widget.likertScale.length - 1,
                label: '${(_selectedOption + 1).toInt()}. '
                    '${widget.likertScale[_selectedOption.floor()]}',
                onChanged: (value) {
                  setState(
                    () {
                      _selectedOption = value;

                      widget.likertAnswer[widget.index] =
                          '${(_selectedOption + 1).toInt()}: '
                          '${widget.likertScale[_selectedOption.floor()]}';
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ...widget.likertScale
                        .asMap()
                        .map(
                          (index, _) => MapEntry(
                            index,
                            Text(
                              (index + 1).toString(),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ]),
            ),
          ],
        ),
      );
}

class SemanticDiffCard extends StatefulWidget {
  const SemanticDiffCard({
    @required this.semanticDiffScale,
    @required this.index,
    @required this.size,
    @required this.shouldAlwaysDisplayValueIndicator,
    @required this.semanticDiffLabels,
    @required this.semanticDiffAnswer,
  })  : assert(semanticDiffScale != null),
        assert(index != null),
        assert(size != null),
        assert(semanticDiffAnswer != null),
        assert(semanticDiffLabels != null),
        assert(shouldAlwaysDisplayValueIndicator != null);

  final List<String> semanticDiffScale;
  final List<String> semanticDiffLabels;
  final List<String> semanticDiffAnswer;
  final int index;
  final int size;
  final bool shouldAlwaysDisplayValueIndicator;

  @override
  State<StatefulWidget> createState() => SemanticDiffCardState();
}

class SemanticDiffCardState extends State<SemanticDiffCard> {
  double _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = (widget.size / 2).floorToDouble();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: SenSemColors.accentLightGray,
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: SenSemColors.lightGray,
                inactiveTrackColor: SenSemColors.lightGray,
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                thumbColor: SenSemColors.windowBlue,
                overlayColor: SenSemColors.primaryColor.withAlpha(32),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
                tickMarkShape:
                    const RoundSliderTickMarkShape(tickMarkRadius: 6),
                activeTickMarkColor: SenSemColors.lightGray,
                inactiveTickMarkColor: SenSemColors.lightGray,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: SenSemColors.windowBlue,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: CustomSlider(
                shouldAlwaysDisplayValueIndicator:
                    widget.shouldAlwaysDisplayValueIndicator,
                value: _selectedOption,
                min: 0,
                max: widget.semanticDiffScale.length.toDouble() - 1,
                divisions: widget.semanticDiffScale.length - 1,
                label: '${widget.semanticDiffScale[_selectedOption.floor()]}',
                onChanged: (value) {
                  setState(
                    () {
                      _selectedOption = value;
                      widget.semanticDiffAnswer[widget.index] =
                          '${widget.semanticDiffScale[_selectedOption.floor()]}';
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ...widget.semanticDiffScale
                      .asMap()
                      .map(
                        (index, _) => MapEntry(
                          index,
                          index == 0
                              ? Text(
                                  widget.semanticDiffLabels[0],
                                )
                              : index == widget.size - 1
                                  ? Text(
                                      widget.semanticDiffLabels[1],
                                    )
                                  : const Text(' '),
                        ),
                      )
                      .values
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      );
}

String createLikertTypeResponse(int length, List<String> answerList) {
  var semanticDiffAnswerString = '';

  for (var i = 0; i < length; i++) {
    semanticDiffAnswerString += answerList[i];
    semanticDiffAnswerString += '_SEP_';
    semanticDiffAnswerString += answerList[i + 1];
  }

  return semanticDiffAnswerString;
}
