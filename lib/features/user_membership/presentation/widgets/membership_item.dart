import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';

class MembershipItem extends StatelessWidget {
  final MembershipModel membership;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const MembershipItem({
    super.key,
    required this.membership,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: membership.enable ? Colors.green : Colors.grey,
          child: Icon(
            membership.enable ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${l10n.value}: \$${(membership.value / 100).toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (membership.dateStart != null)
              Text('${l10n.startDate}: ${_formatDate(membership.dateStart!)}'),
            if (membership.dateEnd != null)
              Text('${l10n.endDate}: ${_formatDate(membership.dateEnd!)}'),
            Text(
              '${l10n.vehicleId}: ${membership.vehicleId}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == l10n.editAction && onEdit != null) {
              onEdit!();
            } else if (value == l10n.deleteAction && onDelete != null) {
              onDelete!();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: l10n.editAction,
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.editAction),
                ],
              ),
            ),
            PopupMenuItem(
              value: l10n.deleteAction,
              child: Row(
                children: [
                  const Icon(Icons.delete, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.deleteAction),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
