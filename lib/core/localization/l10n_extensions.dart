import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Extension on [BuildContext] for concise access to localized strings.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
