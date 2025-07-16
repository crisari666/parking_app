import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final Function(bool) onToggleStatus;
  final VoidCallback onDelete;

  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
    required this.onToggleStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = user.name.isNotEmpty || user.lastName.isNotEmpty
        ? '${user.name} ${user.lastName}'.trim()
        : user.user;
    
    final displayEmail = user.email ?? 'No email';

    return ListTile(
      leading: CircleAvatar(
        child: Text(displayName[0].toUpperCase()),
      ),
      title: Text(displayName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User: ${user.user}'),
          Text('Email: $displayEmail'),
          Text('Role: ${user.role}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: user.isActive,
            onChanged: onToggleStatus,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
} 