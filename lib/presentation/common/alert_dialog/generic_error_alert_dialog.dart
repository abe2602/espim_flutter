import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/alert_dialog/custom_alert_dialog.dart';

class GenericErrorAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomAlertDialog(
        primaryMessage: S.of(context).generic_error_primary_text,
        secondaryMessage: S.of(context).generic_error_secondary_text,
        buttonText: S.of(context).generic_error_button_text,
        icon: Icons.error,
      );
}
