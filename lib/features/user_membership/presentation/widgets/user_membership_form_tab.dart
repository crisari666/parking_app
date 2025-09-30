import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_event.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_state.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form/name_input_field.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form/phone_input_field.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form/plate_number_input_field.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form/vehicle_type_dropdown.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form/date_input_field.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form/cost_input_field.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/widgets/user_membership_form/enable_switch_field.dart';

class UserMembershipFormTab extends StatefulWidget {
  const UserMembershipFormTab({super.key});

  @override
  State<UserMembershipFormTab> createState() => _UserMembershipFormTabState();
}

class _UserMembershipFormTabState extends State<UserMembershipFormTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _costController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate = DateTime.now().add(const Duration(days: 30));
  String _selectedVehicleType = 'car';
  bool _isEnabled = true;
  
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    _plateNumberController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<UserMembershipBloc, UserMembershipState>(
      listener: (context, state) {
        if (state.foundVehicle != null) {
          _autocompleteForm(state.foundVehicle!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.createUserMembership,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                PlateNumberInputField(
                  controller: _plateNumberController,
                  onChanged: _onPlateNumberChanged,
                ),
                const SizedBox(height: 16),
                NameInputField(controller: _nameController),
                const SizedBox(height: 16),
                PhoneInputField(controller: _phoneController),
                const SizedBox(height: 16),
                VehicleTypeDropdown(
                  value: _selectedVehicleType,
                  onChanged: (value) {
                    setState(() {
                      _selectedVehicleType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DateInputField(
                  labelText: l10n.startDate,
                  selectedDate: _startDate,
                  onTap: () => _selectDate(context, true),
                  isStartDate: true,
                ),
                const SizedBox(height: 16),
                DateInputField(
                  labelText: l10n.endDate,
                  selectedDate: _endDate,
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 16),
                CostInputField(controller: _costController),
                const SizedBox(height: 16),
                EnableSwitchField(
                  value: _isEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isEnabled = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(l10n.createMembership),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPlateNumberChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final plateNumber = _plateNumberController.text.trim();
      if (plateNumber.isNotEmpty && plateNumber.length >= 5) {
        context.read<UserMembershipBloc>().add(FindVehicleByPlate(plateNumber));
      }
    });
  }

  void _autocompleteForm(VehicleModel vehicle) {
    setState(() {
      _nameController.text = vehicle.userName;
      _phoneController.text = vehicle.phone;
      _selectedVehicleType = vehicle.vehicleType;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? DateTime.now() : (_startDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: isStartDate ? DateTime.now() : (_startDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Set default end date to one month after start date
          _endDate = picked.add(const Duration(days: 30));
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).pleaseSelectStartAndEndDates),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Convert dates to ISO strings with time
      final startDate = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
      final endDate = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59, 999);

      context.read<UserMembershipBloc>().add(
        CreateUserMembership(
          dateStart: startDate.toIso8601String(),
          dateEnd: endDate.toIso8601String(),
          value: int.parse(_costController.text),
          businessId: "6827c7b431740a022c11dcb5", // TODO: Get from environment or user context
          enable: _isEnabled,
          plateNumber: _plateNumberController.text.toUpperCase(),
          userName: _nameController.text,
          phone: _phoneController.text,
          vehicleType: _selectedVehicleType,
        ),
      );
      
      // Clear form after submission
      _nameController.clear();
      _phoneController.clear();
      _plateNumberController.clear();
      _costController.clear();
      _startDate = null;
      _endDate = DateTime.now().add(const Duration(days: 30));
      _selectedVehicleType = 'car';
      _isEnabled = true;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).userMembershipCreatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
