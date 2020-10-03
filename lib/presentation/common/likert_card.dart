import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/custom_slider.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
