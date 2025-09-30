import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_event.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_state.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/membership_finder.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/membership_list.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/membership_loading_indicator.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/no_membership_found.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/no_active_memberships.dart';

class UserMembershipFinderTab extends StatefulWidget {
  const UserMembershipFinderTab({super.key});

  @override
  State<UserMembershipFinderTab> createState() => _UserMembershipFinderTabState();
}

class _UserMembershipFinderTabState extends State<UserMembershipFinderTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<UserMembershipBloc>().add(LoadActiveMemberships());
  }

  List<MembershipModel> _getFilteredMemberships(List<MembershipModel> memberships) {
    if (_searchQuery.isEmpty) {
      return memberships;
    }
    return memberships.where((membership) {
      return membership.vehicleId.plateNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             membership.vehicleId.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             membership.vehicleId.vehicleType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             membership.businessId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (membership.value / 100).toString().contains(_searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _deleteMembership(String id) {
    // TODO: Add delete event to BLoC when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).userMembershipDeletedSuccessfully),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _editMembership(MembershipModel membership) {
    // TODO: Implement edit functionality
    // This could navigate to an edit page or show a dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).editAction),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _loadActiveMemberships() async {
    context.read<UserMembershipBloc>().add(LoadActiveMemberships());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserMembershipBloc, UserMembershipState>(
      builder: (context, state) {
        final filteredMemberships = _getFilteredMemberships(state.activeMemberships);
        
        return Column(
          children: [
            // Search Section
            MembershipFinder(
              searchController: _searchController,
              searchQuery: _searchQuery,
              onSearchChanged: _onSearchChanged,
              onClearSearch: () {
                _searchController.clear();
                _onSearchChanged('');
              },
              onRefresh: _loadActiveMemberships,
            ),
            
            // Results Section
            Expanded(
              child: state.isLoading
                  ? const MembershipLoadingIndicator()
                  : filteredMemberships.isEmpty && _searchQuery.isNotEmpty
                      ? NoMembershipFound(
                          searchQuery: _searchQuery,
                          onClearSearch: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : filteredMemberships.isEmpty && _searchQuery.isEmpty
                          ? NoActiveMemberships(
                              onCreateMembership: () {
                                // TODO: Navigate to create membership page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context).createUserMembership),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            )
                          : MembershipList(
                              memberships: filteredMemberships,
                              isLoading: state.isLoading,
                              onEdit: () {
                                if (state.selectedActiveMembership != null) {
                                  _editMembership(state.selectedActiveMembership!);
                                }
                              },
                              onDelete: () {
                                if (state.selectedActiveMembership != null) {
                                  _deleteMembership(state.selectedActiveMembership!.id ?? '');
                                }
                              },
                              onItemSelected: (membership) {
                                // TODO: Add select active membership event to BLoC
                              },
                              onRefresh: _loadActiveMemberships,
                            ),
            ),
          ],
        );
      },
    );
  }
}
