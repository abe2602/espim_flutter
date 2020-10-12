import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/alert_dialog/custom_alert_dialog.dart';

class NoInternetAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomAlertDialog(
        primaryMessage: S.of(context).no_internet_primary_text,
        secondaryMessage: S.of(context).no_internet_secondary_text,
        buttonText: S.of(context).no_internet_button_text,
        icon: Icons.error,
      );
}
