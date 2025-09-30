import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form_tab.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_finder_tab.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';

@RoutePage()
class UserMembershipPage extends StatefulWidget {
  const UserMembershipPage({super.key});

  @override
  State<UserMembershipPage> createState() => _UserMembershipPageState();
}

class _UserMembershipPageState extends State<UserMembershipPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //getIt<UserMembershipBloc>().add(LoadUserMemberships());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider.value(
      value: getIt<UserMembershipBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.userMemberships),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.findMemberships),
              Tab(text: l10n.createMembership),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                //context.read<UserMembershipBloc>().add(LoadUserMemberships());
              },
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            UserMembershipFinderTab(),
            UserMembershipFormTab(),
          ],
        ),
      ),
    );
  }
} 