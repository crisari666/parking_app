import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_list.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';

@RoutePage()
class UserMembershipPage extends StatefulWidget {
  const UserMembershipPage({super.key});

  @override
  State<UserMembershipPage> createState() => _UserMembershipPageState();
}

class _UserMembershipPageState extends State<UserMembershipPage> {
  @override
  void initState() {
    super.initState();
    //getIt<UserMembershipBloc>().add(LoadUserMemberships());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider.value(
      value: getIt<UserMembershipBloc>(),
      child: Scaffold(
      appBar: AppBar(
        title: Text(l10n.userMemberships),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              //context.read<UserMembershipBloc>().add(LoadUserMemberships());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Form section
          const UserMembershipForm(),
          
          // Divider
          const Divider(height: 1),
          
          // List section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.existingMemberships,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Expanded(child: UserMembershipList()),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
} 