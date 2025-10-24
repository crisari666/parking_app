import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer/language_selector.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer/users_drawer_option.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer/user_membership_drawer_option.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (authState.userRole != null) ...[
                      Text(
                        authState.userRole!.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const LanguageSelector(),
          const UsersDrawerOption(),
          const UserMembershipDrawerOption(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.setup),
            onTap: () {
              AutoRouter.of(context).push(const SetupRoute());
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printer Setup'),
            onTap: () {
              AutoRouter.of(context).push(const PrinterSetupRoute());
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.about),
            onTap: () {
              AutoRouter.of(context).push(const AboutRoute());
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () {
              AutoRouter.of(context).push(const LogoutRoute());
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}