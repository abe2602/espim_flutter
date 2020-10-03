import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

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
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}
