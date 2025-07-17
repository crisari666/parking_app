import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final Function(bool) onToggleStatus;
  final VoidCallback onDelete;
  final bool isCurrentUser;

  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
    required this.onToggleStatus,
    required this.onDelete,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    final displayName = user.name.isNotEmpty || user.lastName.isNotEmpty
        ? '${user.name} ${user.lastName}'.trim()
        : user.user;
    
    final displayEmail = user.email ?? l10n.noEmail;

    return ListTile(
      leading: CircleAvatar(
        child: Text(displayName[0].toUpperCase()),
      ),
      title: Text(displayName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.user}: ${user.user}'),
          Text('${l10n.email}: $displayEmail'),
          Text('${l10n.role}: ${user.role}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: user.isActive,
            onChanged: isCurrentUser ? null : onToggleStatus,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
} 