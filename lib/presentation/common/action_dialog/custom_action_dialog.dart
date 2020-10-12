import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

// Dialogs used in this project are different than iOS and Android natives
// ones, so there's no need to be adaptive.
class CustomActionDialog extends StatelessWidget {
  const CustomActionDialog({
    @required this.primaryMessage,
    @required this.primaryButtonText,
    @required this.secondaryButtonText,
    this.primaryButtonAction,
    this.secondaryButtonAction,
    this.secondaryMessage,
    this.icon,
    this.shouldDismissOnBackPress = true,
  })  : assert(primaryMessage != null),
        assert(secondaryButtonText != null),
        assert(primaryButtonText != null),
        assert(shouldDismissOnBackPress != null);

  final String primaryMessage;
  final String secondaryMessage;
  final String primaryButtonText;
  final VoidCallback primaryButtonAction;
  final String secondaryButtonText;
  final VoidCallback secondaryButtonAction;
  final IconData icon;
  final bool shouldDismissOnBackPress;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => shouldDismissOnBackPress,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 240,
            width: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Icon(
                  icon,
                  color: SenSemColors.primaryColor,
                ),
                const SizedBox(
                  height: 10,
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
                  height: 10,
                ),
                const Divider(
                  color: Colors.black,
                  height: 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          secondaryButtonAction?.call();
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          secondaryButtonText,
                          style: TextStyle(
                            color: SenSemColors.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FlatButton(
                        color: SenSemColors.primaryColor,
                        onPressed: () {
                          primaryButtonAction?.call();
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          primaryButtonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
