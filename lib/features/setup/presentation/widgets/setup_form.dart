import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_state.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/setup_submit_button.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_name_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_brand_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_monthly_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_monthly_cost_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetupForm extends StatelessWidget {
  const SetupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<SetupBloc, SetupState>(
      builder: (context, state) {
        if (state is SetupLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SetupSuccess) {
          final setup = state.setup;
          return SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Gap(32),
                        BusinessNameField(
                          initialValue: setup?.businessName ?? '',
                          label: l10n.businessName,
                        ),
                        const Gap(16),
                        BusinessBrandField(
                          initialValue: setup?.businessBrand ?? '',
                          label: l10n.businessBrand,
                        ),
                        const Gap(24),
                        Text(
                          l10n.hourlyRates,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(16),
                        CarHourCostField(
                          initialValue: setup?.carHourCost.toString() ?? '',
                          label: l10n.carHourCost,
                        ),
                        const Gap(16),
                        MotorcycleHourCostField(
                          initialValue: setup?.motorcycleHourCost.toString() ?? '',
                          label: l10n.motorcycleHourCost,
                        ),
                        const Gap(24),
                        Text(
                          l10n.monthlyRates,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(16),
                        CarMonthlyCostField(
                          initialValue: setup?.carMonthlyCost.toString() ?? '',
                          label: l10n.carMonthlyCost,
                        ),
                        const Gap(16),
                        MotorcycleMonthlyCostField(
                          initialValue: setup?.motorcycleMonthlyCost.toString() ?? '',
                          label: l10n.motorcycleMonthlyCost,
                        ),
                        const Gap(32),
                        const SetupSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
          );
        }
        
        if (state is SetupError) {
          return Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }
        
        return Container(); // Initial state
      },
    );
  }
} 