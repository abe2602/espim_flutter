import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FixedButtonScrollableBody extends StatefulWidget {
  const FixedButtonScrollableBody({
    @required this.child,
    @required this.fixedChild,
    @required this.scrollController,
  }) : assert(child != null);

  final Widget child;
  final Widget fixedChild;
  final ScrollController scrollController;

  @override
  _FixedButtonScrollableBodyState createState() =>
      _FixedButtonScrollableBodyState();
}

class _FixedButtonScrollableBodyState extends State<FixedButtonScrollableBody> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FadingEdgeScrollView.fromSingleChildScrollView(
              shouldDisposeScrollController: true,
              gradientFractionOnEnd: 0.05,
              gradientFractionOnStart: 0,
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(20),
                child: widget.child,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: widget.fixedChild,
          ),
        ],
      );
}
