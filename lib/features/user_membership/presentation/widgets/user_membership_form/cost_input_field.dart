import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CostInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CostInputField({
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
        labelText: l10n.value,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      keyboardType: TextInputType.number,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterACost;
        }
        if (int.tryParse(value) == null) {
          return l10n.pleaseEnterAValidCost;
        }
        return null;
      },
    );
  }
}
