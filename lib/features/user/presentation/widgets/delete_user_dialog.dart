import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

class DeleteUserDialog extends StatelessWidget {
  final UserModel user;
  final VoidCallback onConfirm;

  const DeleteUserDialog({
    super.key,
    required this.user,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(l10n.deleteUser),
      content: Text(l10n.areYouSureYouWantToDelete(user.user)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(l10n.delete),
        ),
      ],
    );
  }
} 