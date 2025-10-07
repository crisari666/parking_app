import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer/language_selector.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer/users_drawer_option.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer/user_membership_drawer_option.dart';
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
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              l10n.appTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
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