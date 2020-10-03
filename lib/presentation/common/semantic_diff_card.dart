import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/custom_slider.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

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
