import 'package:flutter/material.dart';
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
    return AlertDialog(
      title: const Text('Delete User'),
      content: Text('Are you sure you want to delete ${user.user}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
} 