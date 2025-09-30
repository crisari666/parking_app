import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehicleTypeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const VehicleTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return DropdownButtonFormField<String>(
      value: value,
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
      onChanged: onChanged,
    );
  }
}
