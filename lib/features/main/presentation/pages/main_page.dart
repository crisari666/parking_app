import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/core/utils/custom_scroll_behaviour.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_in_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_out_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/main_page_app_bar.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: const AppDrawer(),
      body: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          if (state is MainError && !state.isCheckin && !state.isCheckout) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: NoGlowScrollBehaviour(),
            child: SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CheckInVehicle(),
                    const SizedBox(height: 16),
                    const CheckOutVehicle(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 