import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_out_vehicel_form/payment_method_selector.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class CheckInVehicleForm extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  CheckInVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is MainError && state.isCheckin) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is CheckInSuccess) {
          _textEditingController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.vehicleCheckedInSuccess)),
          );
          Navigator.of(context).pop(); // Close dialog on success
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc.checkInVehicle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: context.loc.licensePlate,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<MainBloc>().add(PlateNumberChanged(value));
                },
              ),
              const SizedBox(height: 16),
              const Flexible( 
                child: PaymentMethodSelector(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<MainBloc>().add(CheckInRequested());
                },
                child: Text(context.loc.checkIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}