import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class CheckInVehicleForm extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  CheckInVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state.message != null && state.isCheckin) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!), backgroundColor: Colors.red),
          );
        }
        if (state.message != null && !state.isCheckin && !state.isCheckout) {
          // Handle QR code printing messages
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: state.message!.contains('printed successfully') ? Colors.green : Colors.red,
            ),
          );
        }
        if (state.isCheckin) {
          _textEditingController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.vehicleCheckedInSuccess)),
          );
          Navigator.of(context).pop(); // Close dialog on success
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: context.loc.vehicleType,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: 'car',
                child: Text(context.loc.vehicleTypeCar),
              ),
              DropdownMenuItem(
                value: 'motorcycle',
                child: Text(context.loc.vehicleTypeMotorcycle),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<MainBloc>().add(VehicleTypeChanged(value));
              }
            },
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
    );
  }
}