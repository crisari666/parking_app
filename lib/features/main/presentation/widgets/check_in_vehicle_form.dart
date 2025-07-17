import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/printer_connection_indicator.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class CheckInVehicleForm extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  CheckInVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        // Handle check-in success
        if (state.isCheckin) {
          _textEditingController.clear();
          SnackbarService.instance.showSuccessSnackbar(
            context: context,
            message: context.loc.vehicleCheckedInSuccess,
          );
          AutoRouter.of(context).maybePop();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: PrinterConnectionIndicator(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.characters,
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