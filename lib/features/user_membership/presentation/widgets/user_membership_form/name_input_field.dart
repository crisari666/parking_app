import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const NameInputField({
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
        labelText: l10n.fullName,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.person),
      ),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterAName;
        }
        return null;
      },
    );
  }
}
