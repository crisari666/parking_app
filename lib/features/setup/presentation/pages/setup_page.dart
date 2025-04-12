import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Setup'),
      ),
      body: BlocConsumer<SetupBloc, SetupState>(
        listener: (context, state) {
          if (state is SetupSuccess) {
            AutoRouter.of(context).push(const MainRoute());
          } else if (state is SetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<SetupBloc>().add(BusinessNameChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Business Brand',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<SetupBloc>().add(BusinessBrandChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Car Hour Cost',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<SetupBloc>().add(CarHourCostChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Motorcycle Hour Cost',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<SetupBloc>().add(MotorcycleHourCostChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Car Monthly Cost',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<SetupBloc>().add(CarMonthlyCostChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Motorcycle Monthly Cost',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<SetupBloc>().add(MotorcycleMonthlyCostChanged(value));
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<SetupBloc>().add(SetupSubmitted());
                  },
                  child: const Text('Save Setup'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 