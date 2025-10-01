import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.phoneNumber,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterAPhoneNumber;
        }
        return null;
      },
    );
  }
}
