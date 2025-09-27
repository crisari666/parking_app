import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_event.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _plateNumberController.dispose();
    _costController.dispose();
    super.dispose();
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
          print('Start date: $_startDate, End date: $_endDate'); // Debug print
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Debug prints
    print('Build - Start date: $_startDate, End date: $_endDate');
    
    return Padding(
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
              
              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.fullName,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterAName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Phone Number Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterAPhoneNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Plate Number Field
              TextFormField(
                controller: _plateNumberController,
                decoration: InputDecoration(
                  labelText: l10n.plateNumber,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterAPlateNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Vehicle Type Selection
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: InputDecoration(
                  labelText: l10n.vehicleType,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: [
                  DropdownMenuItem(value: 'car', child: Text(l10n.vehicleTypeCar)),
                  DropdownMenuItem(value: 'motorcycle', child: Text(l10n.vehicleTypeMotorcycle)),
                  DropdownMenuItem(value: 'truck', child: Text(l10n.vehicleTypeTruck)),
                  DropdownMenuItem(value: 'van', child: Text(l10n.vehicleTypeVan)),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Start Date Field
              InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.startDate,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _startDate != null 
                        ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                        : l10n.selectDate,
                    style: _startDate != null 
                        ? null 
                        : Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // End Date Field
              InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.endDate,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _endDate != null 
                        ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                        : l10n.selectDate,
                    style: _endDate != null 
                        ? null 
                        : Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Cost Field
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: l10n.value,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterACost;
                  }
                  if (int.tryParse(value) == null) {
                    return l10n.pleaseEnterAValidCost;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Enable/Disable Switch
              Row(
                children: [
                  const Icon(Icons.toggle_on),
                  const SizedBox(width: 8),
                  Text(l10n.enable),
                  const Spacer(),
                  Switch(
                    value: _isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Submit Button
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
    );
  }
}
