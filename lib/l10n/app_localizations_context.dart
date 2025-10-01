import 'package:flutter/widgets.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';


extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}

extension Hardcoded on String {
  String get hardcoded => this;
}
