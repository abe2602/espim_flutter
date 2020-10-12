import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/action_dialog/custom_action_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPermanentlyDeniedActionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomActionDialog(
        primaryMessage:
            S.of(context).permission_denied_permanently_primary_text,
        secondaryMessage:
            S.of(context).permission_denied_permanently_secondary_text,
        primaryButtonText:
            S.of(context).permission_denied_permanently_primary_button_text,
        primaryButtonAction: () async {
          await openAppSettings();
        },
        secondaryButtonText:
            S.of(context).permission_denied_permanently_secondary_button_text,
        icon: Icons.error,
      );
}
