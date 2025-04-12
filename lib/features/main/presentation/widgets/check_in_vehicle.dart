import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';

class CheckInVehicle extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  CheckInVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is MainError && state.isCheckin) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red,));
        }
        if (state is CheckInSuccess) {
          _textEditingController.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle checked in successfully')));
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Check In Vehicle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'License Plate',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<MainBloc>().add(PlateNumberChanged(value));
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Vehicle Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'car',
                  child: Text('Car'),
                ),
                DropdownMenuItem(
                  value: 'motorcycle',
                  child: Text('Motorcycle'),
                ),
              ],
              onChanged: (value) {
                context.read<MainBloc>().add(VehicleTypeChanged(value!));
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<MainBloc>().add(CheckInRequested());
              },
              child: const Text('Check In'),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
