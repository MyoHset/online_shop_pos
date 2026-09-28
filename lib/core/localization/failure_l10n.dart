import '../../l10n/app_localizations.dart';
import '../error/failures.dart';

/// Presentation-layer extension mapping [Failure] to localized user-facing messages.
extension FailureL10n on Failure {
  String message(AppLocalizations l10n) => switch (code) {
        FailureCode.invalidCredentials => l10n.errorInvalidCredentials,
        FailureCode.emailNotConfirmed => l10n.errorEmailNotConfirmed,
        FailureCode.userAlreadyRegistered => l10n.errorUserAlreadyRegistered,
        FailureCode.passwordTooShort => l10n.errorPasswordTooShort,
        FailureCode.insufficientStock => l10n.errorInsufficientStock,
        FailureCode.permissionDenied => l10n.errorPermissionDenied,
        FailureCode.network => l10n.errorNetwork,
        FailureCode.notFound => l10n.errorNotFound,
        FailureCode.validation => l10n.errorValidation,
        FailureCode.discountExceedsLimit => l10n.errorDiscountExceedsLimit,
        FailureCode.server => l10n.errorServer,
        FailureCode.cache => l10n.errorCache,
        FailureCode.imageUpload => l10n.errorImageUpload,
        FailureCode.unknown => l10n.errorUnknown,
      };
}
