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
    context.read<MainBloc>().add(const VehicleTypeChanged('motorcycle'));
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
          // Vehicle Type Selection with Radio Buttons
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Text(
                    context.loc.vehicleType,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
                BlocBuilder<MainBloc, MainState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        RadioListTile<String>(
                          title: Text(context.loc.vehicleTypeCar),
                          value: 'car',
                          groupValue: state.vehicleType.isEmpty ? 'car' : state.vehicleType,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<MainBloc>().add(VehicleTypeChanged(value));
                            }
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        RadioListTile<String>(
                          title: Text(context.loc.vehicleTypeMotorcycle),
                          value: 'motorcycle',
                          groupValue: state.vehicleType.isEmpty ? 'car' : state.vehicleType,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<MainBloc>().add(VehicleTypeChanged(value));
                            }
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
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