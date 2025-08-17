import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/membership_finder.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/membership_list.dart';

class UserMembershipFinderTab extends StatefulWidget {
  const UserMembershipFinderTab({super.key});

  @override
  State<UserMembershipFinderTab> createState() => _UserMembershipFinderTabState();
}

class _UserMembershipFinderTabState extends State<UserMembershipFinderTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<MembershipModel> _memberships = [];
  bool _isLoading = true;
  MembershipModel? _selectedMembership;

  @override
  void initState() {
    super.initState();
    _loadActiveMemberships();
  }

  Future<void> _loadActiveMemberships() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with actual repository call when dependency injection is set up
      // final repository = GetIt.instance<UserMembershipRepository>();
      // final memberships = await repository.getActiveMemberships();
      
      // For now, using mock data that matches the API response format
      await Future.delayed(const Duration(seconds: 1));
      final mockMemberships = [
        MembershipModel(
          id: '68a1f39ffa5db3eefe36da88',
          dateStart: DateTime.parse('2025-08-17T00:00:00.000Z'),
          dateEnd: DateTime.parse('2025-09-17T23:59:59.999Z'),
          value: 60000,
          businessId: '6827c7b431740a022c11dcb5',
          enable: true,
          vehicleId: '6841daf4c626be3bc4f47f9b',
          createdAt: DateTime.parse('2025-08-17T15:22:07.477Z'),
          updatedAt: DateTime.parse('2025-08-17T15:22:07.477Z'),
        ),
      ];

      setState(() {
        _memberships = mockMemberships;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).failedToGetUserMemberships}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<MembershipModel> get _filteredMemberships {
    if (_searchQuery.isEmpty) {
      return _memberships;
    }
    return _memberships.where((membership) {
      return membership.vehicleId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
    // TODO: Replace with actual repository call when dependency injection is set up
    // final repository = GetIt.instance<UserMembershipRepository>();
    // await repository.deleteUserMembership(id);
    
    setState(() {
      _memberships.removeWhere((membership) => membership.id == id);
      if (_selectedMembership?.id == id) {
        _selectedMembership = null;
      }
    });
    
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

  @override
  Widget build(BuildContext context) {
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
          child: _filteredMemberships.isEmpty && _searchQuery.isNotEmpty
              ? Center(
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
                        '${AppLocalizations.of(context).noUserMembershipsFound} ${AppLocalizations.of(context).search} "$_searchQuery"',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppLocalizations.of(context).search} ${AppLocalizations.of(context).vehicleId}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : _filteredMemberships.isEmpty && _searchQuery.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context).noUserMembershipsFound,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context).refresh,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : MembershipList(
                      memberships: _filteredMemberships,
                      isLoading: _isLoading,
                      onEdit: () {
                        if (_selectedMembership != null) {
                          _editMembership(_selectedMembership!);
                        }
                      },
                      onDelete: () {
                        if (_selectedMembership != null) {
                          _deleteMembership(_selectedMembership!.id ?? '');
                        }
                      },
                      onItemSelected: (membership) {
                        setState(() {
                          _selectedMembership = membership;
                        });
                      },
                      onRefresh: _loadActiveMemberships,
                    ),
        ),
      ],
    );
  }
}
