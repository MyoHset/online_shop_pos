import 'package:fpdart/fpdart.dart';

/// Typed failure codes mapped in repositories and localized in presentation.
enum FailureCode {
  invalidCredentials,
  emailNotConfirmed,
  userAlreadyRegistered,
  passwordTooShort,
  insufficientStock,
  permissionDenied,
  network,
  notFound,
  validation,
  discountExceedsLimit,
  server,
  cache,
  imageUpload,
  unknown,
}

/// Base class for all domain-level failures.
///
/// All repository methods return [Either<Failure, T>]. Never throw exceptions
/// across layer boundaries — wrap them in [Failure] subtypes instead.
sealed class Failure {
  const Failure(
    this.message, {
    this.code = FailureCode.unknown,
    this.params = const {},
  });

  /// Raw technical or logged message (never shown directly to the user).
  final String message;

  /// Semantic error code mapped to localized copy in the presentation layer.
  final FailureCode code;

  /// Optional contextual parameters for interpolation.
  final Map<String, dynamic> params;

  @override
  String toString() => '$runtimeType($code): $message';
}

/// Failure originating from the remote server (Supabase / HTTP errors).
final class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    super.code = FailureCode.server,
    super.params,
  });
}

/// Failure due to no network connectivity.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection.',
    FailureCode code = FailureCode.network,
    Map<String, dynamic> params = const {},
  ]) : super(code: code, params: params);
}

/// Failure from local cache operations.
final class CacheFailure extends Failure {
  const CacheFailure(
    super.message, {
    super.code = FailureCode.cache,
    super.params,
  });
}

/// Failure due to invalid input / business-rule violation.
final class ValidationFailure extends Failure {
  const ValidationFailure(
    super.message, {
    super.code = FailureCode.validation,
    super.params,
  });
}

/// Failure when a stock reservation RPC fails (e.g. insufficient stock).
final class StockReservationFailure extends Failure {
  const StockReservationFailure(
    super.message, {
    super.code = FailureCode.insufficientStock,
    super.params,
  });
}

/// Failure when an image upload operation fails.
final class ImageUploadFailure extends Failure {
  const ImageUploadFailure(
    super.message, {
    super.code = FailureCode.imageUpload,
    super.params,
  });
}

/// Failure specifically for authentication errors with typed codes.
final class AuthFailure extends Failure {
  const AuthFailure(
    super.message, {
    required super.code,
    super.params,
  });
}

/// Convenience typedef.
typedef EitherFailure<T> = Either<Failure, T>;
