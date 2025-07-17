import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_state.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/setup_submit_button.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_name_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_brand_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_nit_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_resolution_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/address_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/schedule_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_monthly_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_monthly_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_day_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_day_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_night_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_night_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/student_motorcycle_hour_cost_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';

class SetupForm extends StatelessWidget {
  const SetupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Check if user is a worker - if so, disable all inputs
        final isWorker = authState.userRole == 'worker';
        
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
                            // Show warning message for workers
                            if (isWorker) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.orange.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        l10n.youAreLoggedInAsWorker,
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            
                            const Gap(32),
                            
                            // Business Data Section
                            ExpansionTile(
                              title: Text(
                                l10n.businessData,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              initiallyExpanded: true,
                              children: [
                                const Gap(16),
                                BusinessNameField(
                                  initialValue: setup?.businessName ?? '',
                                  label: l10n.businessName,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                BusinessBrandField(
                                  initialValue: setup?.businessBrand ?? '',
                                  label: l10n.businessBrand,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                BusinessNitField(
                                  initialValue: setup?.businessNit ?? '',
                                  label: l10n.businessNit,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                BusinessResolutionField(
                                  initialValue: setup?.businessResolution ?? '',
                                  label: l10n.businessResolution,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                AddressField(
                                  initialValue: setup?.address ?? '',
                                  label: l10n.address,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                ScheduleField(
                                  initialValue: setup?.schedule ?? '',
                                  label: l10n.schedule,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                              ],
                            ),
                            
                            const Gap(24),
                            
                            // Rates Section
                            ExpansionTile(
                              title: Text(
                                l10n.rates,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              initiallyExpanded: true,
                              children: [
                                const Gap(16),
                                Text(
                                  l10n.hourlyRates,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const Gap(16),
                                CarHourCostField(
                                  initialValue: setup?.carHourCost.toString() ?? '',  
                                  label: l10n.carHourCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                MotorcycleHourCostField(
                                  initialValue: setup?.motorcycleHourCost.toString() ?? '',
                                  label: l10n.motorcycleHourCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                StudentMotorcycleHourCostField(
                                  initialValue: setup?.studentMotorcycleHourCost.toString() ?? '',
                                  label: l10n.studentMotorcycleHourCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(24),
                                Text(
                                  l10n.monthlyRates,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const Gap(16),
                                CarMonthlyCostField(
                                  initialValue: setup?.carMonthlyCost.toString() ?? '',
                                  label: l10n.carMonthlyCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                MotorcycleMonthlyCostField(
                                  initialValue: setup?.motorcycleMonthlyCost.toString() ?? '',
                                  label: l10n.motorcycleMonthlyCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(24),
                                Text(
                                  l10n.dailyRates,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const Gap(16),
                                CarDayCostField(
                                  initialValue: setup?.carDayCost.toString() ?? '',
                                  label: l10n.carDayCost,
                                  enabled: !isWorker,
                                ), 
                                const Gap(16),
                                MotorcycleDayCostField(
                                  initialValue: setup?.motorcycleDayCost.toString() ?? '',
                                  label: l10n.motorcycleDayCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(24),
                                Text(
                                  l10n.nightRates,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const Gap(16),
                                CarNightCostField(
                                  initialValue: setup?.carNightCost.toString() ?? '',
                                  label: l10n.carNightCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                                MotorcycleNightCostField(
                                  initialValue: setup?.motorcycleNightCost.toString() ?? '',
                                  label: l10n.motorcycleNightCost,
                                  enabled: !isWorker,
                                ),
                                const Gap(16),
                              ],
                            ),
                            
                            const Gap(32),
                            // Only show submit button if user is not a worker
                            if (!isWorker) const SetupSubmitButton(),
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
      },
    );
  }
} 