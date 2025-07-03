import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_out_vehicle_form.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class CheckOutVehicle extends StatelessWidget {
  const CheckOutVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => const Dialog(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: CheckOutVehicleForm(),
            ),
          ),
        ).then((value) {
          getIt.get<MainBloc>().add(ResetCheckOutForm());
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.remove_circle_outline, size: 28),
          const SizedBox(width: 12),
          Text(
            context.loc.checkOutVehicle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}