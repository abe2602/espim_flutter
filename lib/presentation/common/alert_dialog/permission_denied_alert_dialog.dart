import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/alert_dialog/custom_alert_dialog.dart';

class PermissionDeniedAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomAlertDialog(
        primaryMessage: S.of(context).permission_denied_primary_text,
        secondaryMessage: S.of(context).permission_denied_secondary_text,
        buttonText: S.of(context).permission_denied_primary_button_text,
        icon: Icons.error,
      );
}
