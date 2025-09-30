import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlateNumberInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onChanged;

  const PlateNumberInputField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.plateNumber,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.directions_car),
      ),
      textCapitalization: TextCapitalization.characters,
      onChanged: onChanged != null ? (_) => onChanged!() : null,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterAPlateNumber;
        }
        return null;
      },
    );
  }
}
