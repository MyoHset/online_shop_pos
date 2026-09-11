import 'package:fpdart/fpdart.dart';

/// Base class for all domain-level failures.
///
/// All repository methods return [Either<Failure, T>]. Never throw exceptions
/// across layer boundaries — wrap them in [Failure] subtypes instead.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Failure originating from the remote server (Supabase / HTTP errors).
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure due to no network connectivity.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Failure from local cache operations.
final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure due to invalid input / business-rule violation.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure when a stock reservation RPC fails (e.g. insufficient stock).
final class StockReservationFailure extends Failure {
  const StockReservationFailure(super.message);
}

/// Failure when an image upload operation fails.
final class ImageUploadFailure extends Failure {
  const ImageUploadFailure(super.message);
}

/// Convenience typedef.
typedef EitherFailure<T> = Either<Failure, T>;
