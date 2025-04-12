import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/setup_submit_button.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_name_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_brand_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_monthly_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_monthly_cost_field.dart';

class SetupForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupBloc, SetupState>(
      builder: (context, state) {
        if (state is SetupLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SetupSuccess) {
          final setup = state.setup;
          // Pre-fill the form fields if setup data exists
          return Form(
            child: Column(
              children: [
                BusinessNameField(
                  initialValue: setup?.businessName ?? '',
                ),
                const Gap(  10),
                BusinessBrandField(
                  initialValue: setup?.businessBrand ?? '',
                ),
                const Gap(10),
                const CarHourCostField(),
                const Gap(10),
                const MotorcycleHourCostField(),
                const Gap(10),
                const CarMonthlyCostField(),
                const Gap(10),
                const MotorcycleMonthlyCostField(),
                const Gap(24),
                const SetupSubmitButton(),
              ],
            ),
          );
        }
        
        if (state is SetupError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        
        return Container(); // Initial state
      },
    );
  }
} 