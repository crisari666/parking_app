import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserMembershipFinderTab extends StatefulWidget {
  const UserMembershipFinderTab({super.key});

  @override
  State<UserMembershipFinderTab> createState() => _UserMembershipFinderTabState();
}

class _UserMembershipFinderTabState extends State<UserMembershipFinderTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Example data - replace with actual data later
  final List<Map<String, dynamic>> _exampleMemberships = [
    {
      'id': '1',
      'name': 'John Doe',
      'phone': '+1 555-0123',
      'created': '2024-01-15',
      'status': 'Active',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'phone': '+1 555-0456',
      'created': '2024-01-10',
      'status': 'Active',
    },
    {
      'id': '3',
      'name': 'Bob Johnson',
      'phone': '+1 555-0789',
      'created': '2024-01-05',
      'status': 'Inactive',
    },
  ];

  List<Map<String, dynamic>> get _filteredMemberships {
    if (_searchQuery.isEmpty) {
      return _exampleMemberships;
    }
    return _exampleMemberships.where((membership) {
      return membership['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             membership['phone'].contains(_searchQuery);
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
    setState(() {
      _exampleMemberships.removeWhere((membership) => membership['id'] == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).userMembershipDeletedSuccessfully),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      children: [
        // Search Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              labelText: l10n.search,
              hintText: 'Search by name or phone number',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
            ),
          ),
        ),
        
        // Results Section
        Expanded(
          child: _filteredMemberships.isEmpty
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
                        _searchQuery.isEmpty
                            ? l10n.noUserMembershipsFound
                            : 'No memberships found for "$_searchQuery"',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _filteredMemberships.length,
                  itemBuilder: (context, index) {
                    final membership = _filteredMemberships[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: membership['status'] == 'Active' 
                              ? Colors.green 
                              : Colors.grey,
                          child: Text(
                            membership['name'][0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          membership['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(membership['phone']),
                            Text(
                              '${l10n.created}: ${membership['created']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              // TODO: Implement edit functionality
                            } else if (value == 'delete') {
                              _deleteMembership(membership['id']);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  const Icon(Icons.edit, size: 20),
                                  const SizedBox(width: 8),
                                  Text(l10n.editAction),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
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
                  },
                ),
        ),
      ],
    );
  }
}
