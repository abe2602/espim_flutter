import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

// Dialogs used in this project are different than iOS and Android natives
// ones, so there's no need to be adaptive.
class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    @required this.primaryMessage,
    @required this.buttonText,
    this.secondaryMessage,
    this.icon,
    this.onPressed,
    this.shouldDismissOnBackPress = true,
  })  : assert(primaryMessage != null),
        assert(buttonText != null),
        assert(shouldDismissOnBackPress != null);

  final String primaryMessage;
  final String secondaryMessage;
  final String buttonText;
  final IconData icon;
  final VoidCallback onPressed;
  final bool shouldDismissOnBackPress;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => shouldDismissOnBackPress,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 240,
            width: 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Icon(
                  icon,
                  color: SenSemColors.primaryColor,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  primaryMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  secondaryMessage ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                const Divider(
                  color: Colors.black,
                  height: 2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    onPressed: () {
                      onPressed?.call();
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: SenSemColors.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
