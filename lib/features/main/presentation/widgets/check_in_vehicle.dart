import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_in_vehicle_form.dart';



class CheckInVehicle extends StatelessWidget {
  const CheckInVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CheckInVehicleForm(),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: const Text(
        'Check In Vehicle',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
