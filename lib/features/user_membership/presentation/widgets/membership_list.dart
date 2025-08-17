import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/membership_item.dart';

class MembershipList extends StatelessWidget {
  final List<MembershipModel> memberships;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isLoading;
  final Function(MembershipModel)? onItemSelected;
  final Future<void> Function()? onRefresh;

  const MembershipList({
    super.key,
    required this.memberships,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
    this.onItemSelected,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (memberships.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noData,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noUserMembershipsFound,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: memberships.length,
        itemBuilder: (context, index) {
          final membership = memberships[index];
          return MembershipItem(
            membership: membership,
            onEdit: onEdit,
            onDelete: onDelete,
            onTap: onItemSelected != null ? () => onItemSelected!(membership) : null,
          );
        },
      ),
    );
  }
}
