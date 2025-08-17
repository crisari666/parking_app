import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_event.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_state.dart';

class UserMembershipList extends StatelessWidget {
  const UserMembershipList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<UserMembershipBloc, UserMembershipState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.memberships.isEmpty) {
          return Center(
            child: Text(
              l10n.noUserMembershipsFound,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: state.memberships.length,
          itemBuilder: (context, index) {
            final membership = state.memberships[index];
            return UserMembershipCard(membership: membership);
          },
        );
      },
    );
  }
}

class UserMembershipCard extends StatelessWidget {
  final UserMembershipModel membership;

  const UserMembershipCard({
    super.key,
    required this.membership,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            membership.name.isNotEmpty ? membership.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          membership.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(membership.email),
            Text(membership.phoneNumber),
            if (membership.createdAt != null)
              Text(
                '${l10n.created}: ${_formatDate(membership.createdAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                context.read<UserMembershipBloc>().add(SelectUserMembership(membership));
                break;
              case 'delete':
                _showDeleteDialog(context);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(width: 8),
                  Text(l10n.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMembership),
        content: Text(l10n.areYouSureYouWantToDeleteMembership(membership.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserMembershipBloc>().add(DeleteUserMembership(membership.id!));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 