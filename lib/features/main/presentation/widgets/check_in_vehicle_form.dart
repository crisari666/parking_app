import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/plate_number_camera.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/printer_connection_indicator.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class CheckInVehicleForm extends StatefulWidget {
  const CheckInVehicleForm({super.key});

  @override
  State<CheckInVehicleForm> createState() => _CheckInVehicleFormState();
}

class _CheckInVehicleFormState extends State<CheckInVehicleForm> {
  final TextEditingController _textEditingController = TextEditingController();
  String _currentPlateNumber = '';

  void _onPlateRecognized(String plateNumber) {
    setState(() {
      _currentPlateNumber = plateNumber;
      _textEditingController.text = plateNumber;
    });
    // Update the bloc with the recognized plate number
    context.read<MainBloc>().add(PlateNumberChanged(plateNumber));
  }

  @override
  Widget build(BuildContext context) {
    context.read<MainBloc>().add(const VehicleTypeChanged('motorcycle'));
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        // Handle check-in success
        if (state.isCheckin) {
          _textEditingController.clear();
          setState(() {
            _currentPlateNumber = '';
          });
          SnackbarService.instance.showSuccessSnackbar(
            context: context,
            message: context.loc.vehicleCheckedInSuccess,
          );
          Navigator.of(context).pop();
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Camera section (top part - direct camera)
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Camera widget taking full space
                  PlateNumberCamera(
                    onPlateRecognized: _onPlateRecognized,
                    initialPlate: _currentPlateNumber,
                  ),
                  
                  // Close button overlay
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  
                  // Printer indicator overlay
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PrinterConnectionIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Form section (bottom part - bottom sheet)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.loc.vehicleDetails,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
          
          // License plate input field
          TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: context.loc.licensePlate,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.directions_car),
              suffixIcon: _currentPlateNumber.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _textEditingController.clear();
                        setState(() {
                          _currentPlateNumber = '';
                        });
                        context.read<MainBloc>().add(const PlateNumberChanged(''));
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              context.read<MainBloc>().add(PlateNumberChanged(value));
              setState(() {
                _currentPlateNumber = value;
              });
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
                BlocBuilder<MainBloc, MainState>(
                  builder: (context, state) {
                    return RadioGroup<String>(
                      groupValue: state.vehicleType.isEmpty ? 'car' : state.vehicleType,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<MainBloc>().add(VehicleTypeChanged(value));
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(context.loc.vehicleTypeCar),
                            value: 'car',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          RadioListTile<String>(
                            title: Text(context.loc.vehicleTypeMotorcycle),
                            value: 'motorcycle',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}