/// Internal exceptions used ONLY within the data layer.
///
/// These are caught in [RepositoryImpl] classes and converted to [Failure]
/// subtypes before returning to the domain layer. Never let these cross
/// layer boundaries.

/// Thrown when a Supabase call fails.
class ServerException implements Exception {
  const ServerException(this.message);

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when a cache operation fails.
class CacheException implements Exception {
  const CacheException(this.message);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when a stock reservation RPC fails due to insufficient stock.
class StockReservationException implements Exception {
  const StockReservationException(this.message);

  final String message;

  @override
  String toString() => 'StockReservationException: $message';
}

/// Thrown when image upload to Supabase Storage fails.
class ImageUploadException implements Exception {
  const ImageUploadException(this.message);

  final String message;

  @override
  String toString() => 'ImageUploadException: $message';
}
