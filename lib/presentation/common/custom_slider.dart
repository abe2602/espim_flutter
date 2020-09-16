import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

typedef SemanticFormatterCallback = String Function(double value);

typedef PaintValueIndicator = void Function(
    PaintingContext context, Offset offset);

enum _SliderType { material, adaptive }

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.shouldAlwaysDisplayValueIndicator = false,
  })  : _sliderType = _SliderType.material,
        assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(value >= min && value <= max),
        assert(divisions == null || divisions > 0),
        super(key: key);

  const CustomSlider.adaptive({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.mouseCursor,
    this.activeColor,
    this.inactiveColor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.shouldAlwaysDisplayValueIndicator = false,
  })  : _sliderType = _SliderType.adaptive,
        assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(value >= min && value <= max),
        assert(divisions == null || divisions > 0),
        super(key: key);

  final double value;

  final ValueChanged<double> onChanged;

  final ValueChanged<double> onChangeStart;

  final ValueChanged<double> onChangeEnd;

  final double min;

  final double max;

  final int divisions;

  final String label;

  final Color activeColor;

  final Color inactiveColor;

  final MouseCursor mouseCursor;

  final SemanticFormatterCallback semanticFormatterCallback;

  final FocusNode focusNode;

  final bool autofocus;

  final _SliderType _sliderType;

  final bool shouldAlwaysDisplayValueIndicator;

  @override
  _CustomSliderState createState() => _CustomSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<double>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has(
        'onChangeStart', onChangeStart));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has(
        'onChangeEnd', onChangeEnd));
    properties.add(DoubleProperty('min', min));
    properties.add(DoubleProperty('max', max));
    properties.add(IntProperty('divisions', divisions));
    properties.add(StringProperty('label', label));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has(
        'semanticFormatterCallback', semanticFormatterCallback));
    properties.add(ObjectFlagProperty<FocusNode>.has('focusNode', focusNode));
    properties
        .add(FlagProperty('autofocus', value: autofocus, ifTrue: 'autofocus'));
  }
}

class _CustomSliderState extends State<CustomSlider>
    with TickerProviderStateMixin {
  static const Duration enableAnimationDuration = Duration(milliseconds: 75);
  static const Duration valueIndicatorAnimationDuration =
  Duration(milliseconds: 100);

  AnimationController overlayController;

  AnimationController valueIndicatorController;

  AnimationController enableController;

  AnimationController positionController;

  Timer interactionTimer;

  final GlobalKey _renderObjectKey = GlobalKey();

  Map<LogicalKeySet, Intent> _shortcutMap;

  Map<Type, Action<Intent>> _actionMap;

  bool get _enabled => widget.onChanged != null;

  PaintValueIndicator paintValueIndicator;

  @override
  void initState() {
    super.initState();
    overlayController = AnimationController(
      duration: kRadialReactionDuration,
      vsync: this,
    );
    valueIndicatorController = AnimationController(
      duration: valueIndicatorAnimationDuration,
      vsync: this,
    );
    enableController = AnimationController(
      duration: enableAnimationDuration,
      vsync: this,
    );
    positionController = AnimationController(
      duration: Duration.zero,
      vsync: this,
    );
    enableController.value = widget.onChanged != null ? 1.0 : 0.0;
    positionController.value = _unlerp(widget.value);
    _shortcutMap = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowUp): const _AdjustSliderIntent.up(),
      LogicalKeySet(LogicalKeyboardKey.arrowDown):
      const _AdjustSliderIntent.down(),
      LogicalKeySet(LogicalKeyboardKey.arrowLeft):
      const _AdjustSliderIntent.left(),
      LogicalKeySet(LogicalKeyboardKey.arrowRight):
      const _AdjustSliderIntent.right(),
    };
    _actionMap = <Type, Action<Intent>>{
      _AdjustSliderIntent: CallbackAction<_AdjustSliderIntent>(
        onInvoke: _actionHandler,
      ),
    };
    if (widget.shouldAlwaysDisplayValueIndicator) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showValueIndicator();
        valueIndicatorController.forward();
      });
    }
  }

  @override
  void dispose() {
    interactionTimer?.cancel();
    overlayController.dispose();
    valueIndicatorController.dispose();
    enableController.dispose();
    positionController.dispose();
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
    super.dispose();
  }

  void _handleChanged(double value) {
    assert(widget.onChanged != null);
    final double lerpValue = _lerp(value);
    if (lerpValue != widget.value) {
      widget.onChanged(lerpValue);
    }
  }

  void _handleDragStart(double value) {
    assert(widget.onChangeStart != null);
    widget.onChangeStart(_lerp(value));
  }

  void _handleDragEnd(double value) {
    assert(widget.onChangeEnd != null);
    widget.onChangeEnd(_lerp(value));
  }

  void _actionHandler(_AdjustSliderIntent intent) {
    final _RenderSlider renderSlider =
    _renderObjectKey.currentContext.findRenderObject() as _RenderSlider;
    final TextDirection textDirection =
    Directionality.of(_renderObjectKey.currentContext);
    switch (intent.type) {
      case _SliderAdjustmentType.right:
        switch (textDirection) {
          case TextDirection.rtl:
            renderSlider.decreaseAction();
            break;
          case TextDirection.ltr:
            renderSlider.increaseAction();
            break;
        }
        break;
      case _SliderAdjustmentType.left:
        switch (textDirection) {
          case TextDirection.rtl:
            renderSlider.increaseAction();
            break;
          case TextDirection.ltr:
            renderSlider.decreaseAction();
            break;
        }
        break;
      case _SliderAdjustmentType.up:
        renderSlider.increaseAction();
        break;
      case _SliderAdjustmentType.down:
        renderSlider.decreaseAction();
        break;
    }
  }

  bool _focused = false;

  void _handleFocusHighlightChanged(bool focused) {
    if (focused != _focused) {
      setState(() {
        _focused = focused;
      });
    }
  }

  bool _hovering = false;

  void _handleHoverChanged(bool hovering) {
    if (hovering != _hovering) {
      setState(() {
        _hovering = hovering;
      });
    }
  }

  double _lerp(double value) {
    assert(value >= 0.0);
    assert(value <= 1.0);
    return value * (widget.max - widget.min) + widget.min;
  }

  double _unlerp(double value) {
    assert(value <= widget.max);
    assert(value >= widget.min);
    return widget.max > widget.min
        ? (value - widget.min) / (widget.max - widget.min)
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));

    switch (widget._sliderType) {
      case _SliderType.material:
        return _buildMaterialSlider(context);

      case _SliderType.adaptive:
        {
          final ThemeData theme = Theme.of(context);
          assert(theme.platform != null);
          switch (theme.platform) {
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.linux:
            case TargetPlatform.windows:
              return _buildMaterialSlider(context);
            case TargetPlatform.iOS:
            case TargetPlatform.macOS:
              return _buildCupertinoSlider(context);
          }
        }
    }
    assert(false);
    return null;
  }

  Widget _buildMaterialSlider(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SliderThemeData sliderTheme = SliderTheme.of(context);

    const double _defaultTrackHeight = 4;
    const SliderTrackShape _defaultTrackShape = RoundedRectSliderTrackShape();
    const SliderTickMarkShape _defaultTickMarkShape =
    RoundSliderTickMarkShape();
    const SliderComponentShape _defaultOverlayShape = RoundSliderOverlayShape();
    const SliderComponentShape _defaultThumbShape = RoundSliderThumbShape();
    const SliderComponentShape _defaultValueIndicatorShape =
    RectangularSliderValueIndicatorShape();
    const ShowValueIndicator _defaultShowValueIndicator =
        ShowValueIndicator.onlyForDiscrete;

    final SliderComponentShape valueIndicatorShape =
        sliderTheme.valueIndicatorShape ?? _defaultValueIndicatorShape;
    Color valueIndicatorColor;
    if (valueIndicatorShape is RectangularSliderValueIndicatorShape) {
      valueIndicatorColor = sliderTheme.valueIndicatorColor ??
          Color.alphaBlend(theme.colorScheme.onSurface.withOpacity(0.60),
              theme.colorScheme.surface.withOpacity(0.90));
    } else {
      valueIndicatorColor = widget.activeColor ??
          sliderTheme.valueIndicatorColor ??
          theme.colorScheme.primary;
    }

    sliderTheme = sliderTheme.copyWith(
      trackHeight: sliderTheme.trackHeight ?? _defaultTrackHeight,
      activeTrackColor: widget.activeColor ??
          sliderTheme.activeTrackColor ??
          theme.colorScheme.primary,
      inactiveTrackColor: widget.inactiveColor ??
          sliderTheme.inactiveTrackColor ??
          theme.colorScheme.primary.withOpacity(0.24),
      disabledActiveTrackColor: sliderTheme.disabledActiveTrackColor ??
          theme.colorScheme.onSurface.withOpacity(0.32),
      disabledInactiveTrackColor: sliderTheme.disabledInactiveTrackColor ??
          theme.colorScheme.onSurface.withOpacity(0.12),
      activeTickMarkColor: widget.inactiveColor ??
          sliderTheme.activeTickMarkColor ??
          theme.colorScheme.onPrimary.withOpacity(0.54),
      inactiveTickMarkColor: widget.activeColor ??
          sliderTheme.inactiveTickMarkColor ??
          theme.colorScheme.primary.withOpacity(0.54),
      disabledActiveTickMarkColor: sliderTheme.disabledActiveTickMarkColor ??
          theme.colorScheme.onPrimary.withOpacity(0.12),
      disabledInactiveTickMarkColor:
      sliderTheme.disabledInactiveTickMarkColor ??
          theme.colorScheme.onSurface.withOpacity(0.12),
      thumbColor: widget.activeColor ??
          sliderTheme.thumbColor ??
          theme.colorScheme.primary,
      disabledThumbColor: sliderTheme.disabledThumbColor ??
          Color.alphaBlend(theme.colorScheme.onSurface.withOpacity(.38),
              theme.colorScheme.surface),
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          sliderTheme.overlayColor ??
          theme.colorScheme.primary.withOpacity(0.12),
      valueIndicatorColor: valueIndicatorColor,
      trackShape: sliderTheme.trackShape ?? _defaultTrackShape,
      tickMarkShape: sliderTheme.tickMarkShape ?? _defaultTickMarkShape,
      thumbShape: sliderTheme.thumbShape ?? _defaultThumbShape,
      overlayShape: sliderTheme.overlayShape ?? _defaultOverlayShape,
      valueIndicatorShape: valueIndicatorShape,
      showValueIndicator:
      sliderTheme.showValueIndicator ?? _defaultShowValueIndicator,
      valueIndicatorTextStyle: sliderTheme.valueIndicatorTextStyle ??
          theme.textTheme.bodyText1.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
    );
    final MouseCursor effectiveMouseCursor =
    MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!_enabled) MaterialState.disabled,
        if (_hovering) MaterialState.hovered,
        if (_focused) MaterialState.focused,
      },
    );

    Size _screenSize() => MediaQuery.of(context).size;

    return Semantics(
      container: true,
      child: FocusableActionDetector(
        actions: _actionMap,
        shortcuts: _shortcutMap,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: _enabled,
        onShowFocusHighlight: _handleFocusHighlightChanged,
        onShowHoverHighlight: _handleHoverChanged,
        mouseCursor: effectiveMouseCursor,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: _SliderRenderObjectWidget(
            key: _renderObjectKey,
            value: _unlerp(widget.value),
            divisions: widget.divisions,
            label: widget.label,
            sliderTheme: sliderTheme,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            screenSize: _screenSize(),
            onChanged: (widget.onChanged != null) && (widget.max > widget.min)
                ? _handleChanged
                : null,
            onChangeStart:
            widget.onChangeStart != null ? _handleDragStart : null,
            onChangeEnd: widget.onChangeEnd != null ? _handleDragEnd : null,
            state: this,
            semanticFormatterCallback: widget.semanticFormatterCallback,
            hasFocus: _focused,
            hovering: _hovering,
            shouldAlwaysDisplayValueIndicator:
            widget.shouldAlwaysDisplayValueIndicator,
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoSlider(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlider(
        value: widget.value,
        onChanged: widget.onChanged,
        onChangeStart: widget.onChangeStart,
        onChangeEnd: widget.onChangeEnd,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        activeColor: widget.activeColor,
      ),
    );
  }

  final LayerLink _layerLink = LayerLink();

  OverlayEntry overlayEntry;

  void showValueIndicator() {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _layerLink,
            child: _ValueIndicatorRenderObjectWidget(
              state: this,
            ),
          );
        },
      );
      Overlay.of(context).insert(overlayEntry);
    }
  }
}

class _SliderRenderObjectWidget extends LeafRenderObjectWidget {
  const _SliderRenderObjectWidget({
    Key key,
    this.value,
    this.divisions,
    this.label,
    this.sliderTheme,
    this.textScaleFactor,
    this.screenSize,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.state,
    this.semanticFormatterCallback,
    this.hasFocus,
    this.hovering,
    this.shouldAlwaysDisplayValueIndicator,
  }) : super(key: key);

  final double value;
  final int divisions;
  final String label;
  final SliderThemeData sliderTheme;
  final double textScaleFactor;
  final Size screenSize;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final SemanticFormatterCallback semanticFormatterCallback;
  final _CustomSliderState state;
  final bool hasFocus;
  final bool hovering;
  final bool shouldAlwaysDisplayValueIndicator;

  @override
  _RenderSlider createRenderObject(BuildContext context) {
    return _RenderSlider(
      value: value,
      divisions: divisions,
      label: label,
      sliderTheme: sliderTheme,
      textScaleFactor: textScaleFactor,
      screenSize: screenSize,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      state: state,
      textDirection: Directionality.of(context),
      semanticFormatterCallback: semanticFormatterCallback,
      platform: Theme.of(context).platform,
      hasFocus: hasFocus,
      hovering: hovering,
      shouldAlwaysDisplayValueIndicator: shouldAlwaysDisplayValueIndicator,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSlider renderObject) {
    renderObject
      ..value = value
      ..divisions = divisions
      ..label = label
      ..sliderTheme = sliderTheme
      ..theme = Theme.of(context)
      ..textScaleFactor = textScaleFactor
      ..screenSize = screenSize
      ..onChanged = onChanged
      ..onChangeStart = onChangeStart
      ..onChangeEnd = onChangeEnd
      ..textDirection = Directionality.of(context)
      ..semanticFormatterCallback = semanticFormatterCallback
      ..platform = Theme.of(context).platform
      ..hasFocus = hasFocus
      ..hovering = hovering
      ..shouldAlwaysDisplayValueIndicator = shouldAlwaysDisplayValueIndicator;
  }
}

class _RenderSlider extends RenderBox with RelayoutWhenSystemFontsChangeMixin {
  _RenderSlider({
    @required double value,
    int divisions,
    String label,
    SliderThemeData sliderTheme,
    double textScaleFactor,
    Size screenSize,
    TargetPlatform platform,
    ValueChanged<double> onChanged,
    SemanticFormatterCallback semanticFormatterCallback,
    this.onChangeStart,
    this.onChangeEnd,
    @required _CustomSliderState state,
    @required TextDirection textDirection,
    bool hasFocus,
    bool hovering,
    this.shouldAlwaysDisplayValueIndicator,
  })  : assert(value != null && value >= 0.0 && value <= 1.0),
        assert(state != null),
        assert(textDirection != null),
        _platform = platform,
        _semanticFormatterCallback = semanticFormatterCallback,
        _label = label,
        _value = value,
        _divisions = divisions,
        _sliderTheme = sliderTheme,
        _textScaleFactor = textScaleFactor,
        _screenSize = screenSize,
        _onChanged = onChanged,
        _state = state,
        _textDirection = textDirection,
        _hasFocus = hasFocus,
        _hovering = hovering {
    _updateLabelPainter();
    final GestureArenaTeam team = GestureArenaTeam();
    _drag = HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _endInteraction;
    _tap = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTapCancel = _endInteraction;
    _overlayAnimation = CurvedAnimation(
      parent: _state.overlayController,
      curve: Curves.fastOutSlowIn,
    );
    _valueIndicatorAnimation = CurvedAnimation(
      parent: _state.valueIndicatorController,
      curve: Curves.fastOutSlowIn,
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed &&
          _state.overlayEntry != null) {
        _state.overlayEntry.remove();
        _state.overlayEntry = null;
      }
    });
    _enableAnimation = CurvedAnimation(
      parent: _state.enableController,
      curve: Curves.easeInOut,
    );
  }

  static const Duration _positionAnimationDuration = Duration(milliseconds: 75);
  static const Duration _minimumInteractionTime = Duration(milliseconds: 500);

  static const double _minPreferredTrackWidth = 144.0;

  double get _maxSliderPartWidth =>
      _sliderPartSizes.map((Size size) => size.width).reduce(math.max);

  double get _maxSliderPartHeight =>
      _sliderPartSizes.map((Size size) => size.height).reduce(math.max);

  List<Size> get _sliderPartSizes => <Size>[
    _sliderTheme.overlayShape.getPreferredSize(isInteractive, isDiscrete),
    _sliderTheme.thumbShape.getPreferredSize(isInteractive, isDiscrete),
    _sliderTheme.tickMarkShape.getPreferredSize(
        isEnabled: isInteractive, sliderTheme: sliderTheme),
  ];

  double get _minPreferredTrackHeight => _sliderTheme.trackHeight;

  final _CustomSliderState _state;
  Animation<double> _overlayAnimation;
  Animation<double> _valueIndicatorAnimation;
  Animation<double> _enableAnimation;
  final TextPainter _labelPainter = TextPainter();
  HorizontalDragGestureRecognizer _drag;
  TapGestureRecognizer _tap;
  bool _active = false;
  double _currentDragValue = 0.0;

  Rect get _trackRect => _sliderTheme.trackShape.getPreferredRect(
    parentBox: this,
    offset: Offset.zero,
    sliderTheme: _sliderTheme,
    isDiscrete: false,
  );

  bool get isInteractive => onChanged != null;

  bool get isDiscrete => divisions != null && divisions > 0;

  double get value => _value;
  double _value;

  bool shouldAlwaysDisplayValueIndicator;

  set value(double newValue) {
    assert(newValue != null && newValue >= 0.0 && newValue <= 1.0);
    final double convertedValue = isDiscrete ? _discretize(newValue) : newValue;
    if (convertedValue == _value) {
      return;
    }
    _value = convertedValue;
    if (isDiscrete) {
      final double distance = (_value - _state.positionController.value).abs();
      _state.positionController.duration = distance != 0.0
          ? _positionAnimationDuration * (1.0 / distance)
          : Duration.zero;
      _state.positionController
          .animateTo(convertedValue, curve: Curves.easeInOut);
    } else {
      _state.positionController.value = convertedValue;
    }
    markNeedsSemanticsUpdate();
  }

  TargetPlatform _platform;

  TargetPlatform get platform => _platform;

  set platform(TargetPlatform value) {
    if (_platform == value) return;
    _platform = value;
    markNeedsSemanticsUpdate();
  }

  SemanticFormatterCallback _semanticFormatterCallback;

  SemanticFormatterCallback get semanticFormatterCallback =>
      _semanticFormatterCallback;

  set semanticFormatterCallback(SemanticFormatterCallback value) {
    if (_semanticFormatterCallback == value) return;
    _semanticFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  int get divisions => _divisions;
  int _divisions;

  set divisions(int value) {
    if (value == _divisions) {
      return;
    }
    _divisions = value;
    markNeedsPaint();
  }

  String get label => _label;
  String _label;

  set label(String value) {
    if (value == _label) {
      return;
    }
    _label = value;
    _updateLabelPainter();
  }

  SliderThemeData get sliderTheme => _sliderTheme;
  SliderThemeData _sliderTheme;

  set sliderTheme(SliderThemeData value) {
    if (value == _sliderTheme) {
      return;
    }
    _sliderTheme = value;
    markNeedsPaint();
  }

  ThemeData get theme => _theme;
  ThemeData _theme;

  set theme(ThemeData value) {
    if (value == _theme) {
      return;
    }
    _theme = value;
    markNeedsPaint();
  }

  double get textScaleFactor => _textScaleFactor;
  double _textScaleFactor;

  set textScaleFactor(double value) {
    if (value == _textScaleFactor) {
      return;
    }
    _textScaleFactor = value;
    _updateLabelPainter();
  }

  Size get screenSize => _screenSize;
  Size _screenSize;

  set screenSize(Size value) {
    if (value == _screenSize) {
      return;
    }
    _screenSize = value;
    markNeedsPaint();
  }

  ValueChanged<double> get onChanged => _onChanged;
  ValueChanged<double> _onChanged;

  set onChanged(ValueChanged<double> value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      if (isInteractive) {
        _state.enableController.forward();
      } else {
        _state.enableController.reverse();
      }
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  ValueChanged<double> onChangeStart;
  ValueChanged<double> onChangeEnd;

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    assert(value != null);
    if (value == _textDirection) {
      return;
    }
    _textDirection = value;
    _updateLabelPainter();
  }

  bool get hasFocus => _hasFocus;
  bool _hasFocus;

  set hasFocus(bool value) {
    assert(value != null);
    if (value == _hasFocus) return;
    _hasFocus = value;
    _updateForFocusOrHover(_hasFocus);
    markNeedsSemanticsUpdate();
  }

  bool get hovering => _hovering;
  bool _hovering;

  set hovering(bool value) {
    assert(value != null);
    if (value == _hovering) return;
    _hovering = value;
    _updateForFocusOrHover(_hovering);
  }

  void _updateForFocusOrHover(bool hasFocusOrIsHovering) {
    if (hasFocusOrIsHovering) {
      _state.overlayController.forward();
      if (showValueIndicator) {
        _state.valueIndicatorController.forward();
      }
    } else {
      _state.overlayController.reverse();
      if (showValueIndicator && !shouldAlwaysDisplayValueIndicator) {
        _state.valueIndicatorController.reverse();
      }
    }
  }

  bool get showValueIndicator {
    bool showValueIndicator;
    switch (_sliderTheme.showValueIndicator) {
      case ShowValueIndicator.onlyForDiscrete:
        showValueIndicator = isDiscrete;
        break;
      case ShowValueIndicator.onlyForContinuous:
        showValueIndicator = !isDiscrete;
        break;
      case ShowValueIndicator.always:
        showValueIndicator = true;
        break;
      case ShowValueIndicator.never:
        showValueIndicator = false;
        break;
    }
    return showValueIndicator;
  }

  double get _adjustmentUnit {
    switch (_platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return 0.1;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return 0.05;
    }
    assert(false, 'Unhandled TargetPlatform $_platform');
    return 0.0;
  }

  void _updateLabelPainter() {
    if (label != null) {
      _labelPainter
        ..text = TextSpan(
          style: _sliderTheme.valueIndicatorTextStyle,
          text: label,
        )
        ..textDirection = textDirection
        ..textScaleFactor = textScaleFactor
        ..layout();
    } else {
      _labelPainter.text = null;
    }

    markNeedsLayout();
  }

  @override
  void systemFontsDidChange() {
    super.systemFontsDidChange();
    _labelPainter.markNeedsLayout();
    _updateLabelPainter();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _overlayAnimation.addListener(markNeedsPaint);
    _valueIndicatorAnimation.addListener(markNeedsPaint);
    _enableAnimation.addListener(markNeedsPaint);
    _state.positionController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _overlayAnimation.removeListener(markNeedsPaint);
    _valueIndicatorAnimation.removeListener(markNeedsPaint);
    _enableAnimation.removeListener(markNeedsPaint);
    _state.positionController.removeListener(markNeedsPaint);
    super.detach();
  }

  double _getValueFromVisualPosition(double visualPosition) {
    switch (textDirection) {
      case TextDirection.rtl:
        return 1.0 - visualPosition;
      case TextDirection.ltr:
        return visualPosition;
    }
    return null;
  }

  double _getValueFromGlobalPosition(Offset globalPosition) {
    final double visualPosition =
        (globalToLocal(globalPosition).dx - _trackRect.left) / _trackRect.width;
    return _getValueFromVisualPosition(visualPosition);
  }

  double _discretize(double value) {
    double result = value.clamp(0.0, 1.0) as double;
    if (isDiscrete) {
      result = (result * divisions).round() / divisions;
    }
    return result;
  }

  void _startInteraction(Offset globalPosition) {
    _state.showValueIndicator();
    if (isInteractive) {
      _active = true;

      if (onChangeStart != null) {
        onChangeStart(_discretize(value));
      }
      _currentDragValue = _getValueFromGlobalPosition(globalPosition);
      onChanged(_discretize(_currentDragValue));
      _state.overlayController.forward();
      if (showValueIndicator) {
        _state.valueIndicatorController.forward();
        _state.interactionTimer?.cancel();
        _state.interactionTimer =
            Timer(_minimumInteractionTime * timeDilation, () {
              _state.interactionTimer = null;
              if (!_active &&
                  _state.valueIndicatorController.status ==
                      AnimationStatus.completed &&
                  !shouldAlwaysDisplayValueIndicator) {
                _state.valueIndicatorController.reverse();
              }
            });
      }
    }
  }

  void _endInteraction() {
    if (!_state.mounted) {
      return;
    }

    if (_active && _state.mounted) {
      if (onChangeEnd != null) {
        onChangeEnd(_discretize(_currentDragValue));
      }
      _active = false;
      _currentDragValue = 0.0;
      _state.overlayController.reverse();

      if (showValueIndicator &&
          _state.interactionTimer == null &&
          !shouldAlwaysDisplayValueIndicator) {
        _state.valueIndicatorController.reverse();
      }
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _startInteraction(details.globalPosition);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_state.mounted) {
      return;
    }

    if (isInteractive) {
      final double valueDelta = details.primaryDelta / _trackRect.width;
      switch (textDirection) {
        case TextDirection.rtl:
          _currentDragValue -= valueDelta;
          break;
        case TextDirection.ltr:
          _currentDragValue += valueDelta;
          break;
      }
      onChanged(_discretize(_currentDragValue));
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _handleTapDown(TapDownDetails details) {
    _startInteraction(details.globalPosition);
  }

  void _handleTapUp(TapUpDetails details) {
    _endInteraction();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _minPreferredTrackWidth + _maxSliderPartWidth;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _minPreferredTrackWidth + _maxSliderPartWidth;

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(_minPreferredTrackHeight, _maxSliderPartHeight);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(_minPreferredTrackHeight, _maxSliderPartHeight);

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = Size(
      constraints.hasBoundedWidth
          ? constraints.maxWidth
          : _minPreferredTrackWidth + _maxSliderPartWidth,
      constraints.hasBoundedHeight
          ? constraints.maxHeight
          : math.max(_minPreferredTrackHeight, _maxSliderPartHeight),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final double value = _state.positionController.value;

    double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - value;
        break;
      case TextDirection.ltr:
        visualPosition = value;
        break;
    }

    final Rect trackRect = _sliderTheme.trackShape.getPreferredRect(
      parentBox: this,
      offset: offset,
      sliderTheme: _sliderTheme,
      isDiscrete: isDiscrete,
    );
    final Offset thumbCenter = Offset(
        trackRect.left + visualPosition * trackRect.width, trackRect.center.dy);

    _sliderTheme.trackShape.paint(
      context,
      offset,
      parentBox: this,
      sliderTheme: _sliderTheme,
      enableAnimation: _enableAnimation,
      textDirection: _textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isInteractive,
    );

    if (!_overlayAnimation.isDismissed) {
      _sliderTheme.overlayShape.paint(
        context,
        thumbCenter,
        activationAnimation: _overlayAnimation,
        enableAnimation: _enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: _labelPainter,
        parentBox: this,
        sliderTheme: _sliderTheme,
        textDirection: _textDirection,
        value: _value,
      );
    }

    if (isDiscrete) {
      final double tickMarkWidth = _sliderTheme.tickMarkShape
          .getPreferredSize(
        isEnabled: isInteractive,
        sliderTheme: _sliderTheme,
      )
          .width;
      final double padding = trackRect.height;
      final double adjustedTrackWidth = trackRect.width - padding;

      if (adjustedTrackWidth / divisions >= 3.0 * tickMarkWidth) {
        final double dy = trackRect.center.dy;
        for (int i = 0; i <= divisions; i++) {
          final double value = i / divisions;

          final double dx =
              trackRect.left + value * adjustedTrackWidth + padding / 2;
          final Offset tickMarkOffset = Offset(dx, dy);
          _sliderTheme.tickMarkShape.paint(
            context,
            tickMarkOffset,
            parentBox: this,
            sliderTheme: _sliderTheme,
            enableAnimation: _enableAnimation,
            textDirection: _textDirection,
            thumbCenter: thumbCenter,
            isEnabled: isInteractive,
          );
        }
      }
    }

    if (isInteractive &&
        label != null &&
        !_valueIndicatorAnimation.isDismissed) {
      if (showValueIndicator) {
        _state.paintValueIndicator = (PaintingContext context, Offset offset) {
          if (attached) {
            _sliderTheme.valueIndicatorShape.paint(
              context,
              offset + thumbCenter,
              activationAnimation: _valueIndicatorAnimation,
              enableAnimation: _enableAnimation,
              isDiscrete: isDiscrete,
              labelPainter: _labelPainter,
              parentBox: this,
              sliderTheme: _sliderTheme,
              textDirection: _textDirection,
              value: _value,
              textScaleFactor: textScaleFactor,
              sizeWithOverflow: screenSize.isEmpty ? size : screenSize,
            );
          }
        };
      }
    }

    _sliderTheme.thumbShape.paint(
      context,
      thumbCenter,
      activationAnimation: _overlayAnimation,
      enableAnimation: _enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: _labelPainter,
      parentBox: this,
      sliderTheme: _sliderTheme,
      textDirection: _textDirection,
      sizeWithOverflow: screenSize.isEmpty ? size : screenSize,
      value: _value,
    );
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = false;

    config.isEnabled = isInteractive;
    config.textDirection = textDirection;
    if (isInteractive) {
      config.onIncrease = increaseAction;
      config.onDecrease = decreaseAction;
    }
    config.label = _label ?? '';
    if (semanticFormatterCallback != null) {
      config.value = semanticFormatterCallback(_state._lerp(value));
      config.increasedValue = semanticFormatterCallback(_state
          ._lerp((value + _semanticActionUnit).clamp(0.0, 1.0) as double));
      config.decreasedValue = semanticFormatterCallback(_state
          ._lerp((value - _semanticActionUnit).clamp(0.0, 1.0) as double));
    } else {
      config.value = '${(value * 100).round()}%';
      config.increasedValue =
      '${((value + _semanticActionUnit).clamp(0.0, 1.0) * 100).round()}%';
      config.decreasedValue =
      '${((value - _semanticActionUnit).clamp(0.0, 1.0) * 100).round()}%';
    }
  }

  double get _semanticActionUnit =>
      divisions != null ? 1.0 / divisions : _adjustmentUnit;

  void increaseAction() {
    if (isInteractive) {
      onChanged((value + _semanticActionUnit).clamp(0.0, 1.0) as double);
    }
  }

  void decreaseAction() {
    if (isInteractive) {
      onChanged((value - _semanticActionUnit).clamp(0.0, 1.0) as double);
    }
  }
}

class _AdjustSliderIntent extends Intent {
  const _AdjustSliderIntent({@required this.type});

  const _AdjustSliderIntent.right() : type = _SliderAdjustmentType.right;

  const _AdjustSliderIntent.left() : type = _SliderAdjustmentType.left;

  const _AdjustSliderIntent.up() : type = _SliderAdjustmentType.up;

  const _AdjustSliderIntent.down() : type = _SliderAdjustmentType.down;

  final _SliderAdjustmentType type;
}

enum _SliderAdjustmentType {
  right,
  left,
  up,
  down,
}

class _ValueIndicatorRenderObjectWidget extends LeafRenderObjectWidget {
  const _ValueIndicatorRenderObjectWidget({
    this.state,
  });

  final _CustomSliderState state;

  @override
  _RenderValueIndicator createRenderObject(BuildContext context) {
    return _RenderValueIndicator(
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderValueIndicator renderObject) {
    renderObject._state = state;
  }
}

class _RenderValueIndicator extends RenderBox
    with RelayoutWhenSystemFontsChangeMixin {
  _RenderValueIndicator({
    _CustomSliderState state,
  }) : _state = state {
    _valueIndicatorAnimation = CurvedAnimation(
      parent: _state.valueIndicatorController,
      curve: Curves.fastOutSlowIn,
    );
  }

  Animation<double> _valueIndicatorAnimation;
  _CustomSliderState _state;

  @override
  bool get sizedByParent => true;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _valueIndicatorAnimation.addListener(markNeedsPaint);
    _state.positionController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _valueIndicatorAnimation.removeListener(markNeedsPaint);
    _state.positionController.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_state.paintValueIndicator != null) {
      _state.paintValueIndicator(context, offset);
    }
  }
}
