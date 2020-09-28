import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

// After talking to QA and Designer, all icons behavior were decided. We must
// not ellipsis the text. It should break lines, because of that, there's no
// need to define an overflow behavior here.
class IconedText extends StatelessWidget {
  const IconedText({
    @required this.icon,
    @required this.text,
    this.textStyle,
  })  : assert(icon != null),
        assert(text != null);

  final IconData icon;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle ??
                  TextStyle(
                    color: SenSemColors.lightGray,
                    fontSize: 14,
                  ),
            ),
          ),
        ],
      );
}
