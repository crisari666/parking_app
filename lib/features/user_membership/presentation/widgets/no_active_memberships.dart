import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';

class NoActiveMemberships extends StatelessWidget {
  final VoidCallback? onCreateMembership;

  const NoActiveMemberships({
    super.key,
    this.onCreateMembership,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_membership,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noUserMembershipsFound,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.noUserMembershipsFound}. ${l10n.createUserMembership}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onCreateMembership != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onCreateMembership,
                icon: const Icon(Icons.add),
                label: Text(l10n.createUserMembership),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
