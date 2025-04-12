import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/setup_submit_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_name_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/business_brand_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_hour_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/car_monthly_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/motorcycle_monthly_cost_field.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';

@RoutePage()
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetupBloc(
        localDatasource: context.read<SetupLocalDatasource>(),
      )..add(SetupStarted()),
      child: SetupForm(),
    );
  }
}

class SetupForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupBloc, SetupState>(
      builder: (context, state) {
        if (state is SetupLoading) {
          return Center(child: CircularProgressIndicator());
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
                BusinessBrandField(
                  initialValue: setup?.businessBrand ?? '',
                ),
                CarHourCostField(),
                MotorcycleHourCostField(),
                CarMonthlyCostField(),
                MotorcycleMonthlyCostField(),
                SizedBox(height: 24),
                SetupSubmitButton(),
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

