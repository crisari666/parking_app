import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

class MainPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text('Quantum Parking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              AutoRouter.of(context).push(const RecordsRoute());
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              AutoRouter.of(context).push(const ClosureRoute());
            },
          ),
      ],
    );  
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
