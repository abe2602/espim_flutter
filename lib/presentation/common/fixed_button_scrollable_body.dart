import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FixedButtonScrollableBody extends StatefulWidget {
  const FixedButtonScrollableBody({
    @required this.child,
    @required this.fixedChild,
  })  : assert(child != null),
        assert(fixedChild != null);

  final Widget child;
  final Widget fixedChild;

  @override
  _FixedButtonScrollableBodyState createState() =>
      _FixedButtonScrollableBodyState();
}

class _FixedButtonScrollableBodyState extends State<FixedButtonScrollableBody> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FadingEdgeScrollView.fromSingleChildScrollView(
              shouldDisposeScrollController: false,
              gradientFractionOnEnd: 0.05,
              gradientFractionOnStart: 0,
              child: SingleChildScrollView(
                controller: scrollController,
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
