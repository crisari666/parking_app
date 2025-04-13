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
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            Icon(Icons.add_circle_outline, size: 28),
            SizedBox(width: 12),
            Text(
            'Check In Vehicle',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
