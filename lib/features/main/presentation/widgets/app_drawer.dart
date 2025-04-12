import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Quantum Parking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Setup'),
            onTap: () {
              AutoRouter.of(context).push(const SetupRoute());
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}