// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardRemoteDataSource)
const dashboardRemoteDataSourceProvider = DashboardRemoteDataSourceProvider._();

final class DashboardRemoteDataSourceProvider extends $FunctionalProvider<
    DashboardRemoteDataSource,
    DashboardRemoteDataSource,
    DashboardRemoteDataSource> with $Provider<DashboardRemoteDataSource> {
  const DashboardRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DashboardRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardRemoteDataSource create(Ref ref) {
    return dashboardRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRemoteDataSource>(value),
    );
  }
}

String _$dashboardRemoteDataSourceHash() =>
    r'9a46fc4b9198a27cc96f83837132c26418d73c40';

@ProviderFor(dashboardRepository)
const dashboardRepositoryProvider = DashboardRepositoryProvider._();

final class DashboardRepositoryProvider extends $FunctionalProvider<
    DashboardRepository,
    DashboardRepository,
    DashboardRepository> with $Provider<DashboardRepository> {
  const DashboardRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRepository>(value),
    );
  }
}

String _$dashboardRepositoryHash() =>
    r'5a8fce339f8fd826273081df3d529fa8aaf58d25';

@ProviderFor(todaySalesSummary)
const todaySalesSummaryProvider = TodaySalesSummaryProvider._();

final class TodaySalesSummaryProvider extends $FunctionalProvider<
        AsyncValue<TodaySalesSummary>,
        TodaySalesSummary,
        FutureOr<TodaySalesSummary>>
    with
        $FutureModifier<TodaySalesSummary>,
        $FutureProvider<TodaySalesSummary> {
  const TodaySalesSummaryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todaySalesSummaryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todaySalesSummaryHash();

  @$internal
  @override
  $FutureProviderElement<TodaySalesSummary> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TodaySalesSummary> create(Ref ref) {
    return todaySalesSummary(ref);
  }
}

String _$todaySalesSummaryHash() => r'cc5be9ec41b55daecb03df79c5b2177ae961da66';

@ProviderFor(orderStatusCounts)
const orderStatusCountsProvider = OrderStatusCountsProvider._();

final class OrderStatusCountsProvider extends $FunctionalProvider<
        AsyncValue<List<OrderStatusCount>>,
        List<OrderStatusCount>,
        FutureOr<List<OrderStatusCount>>>
    with
        $FutureModifier<List<OrderStatusCount>>,
        $FutureProvider<List<OrderStatusCount>> {
  const OrderStatusCountsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'orderStatusCountsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderStatusCountsHash();

  @$internal
  @override
  $FutureProviderElement<List<OrderStatusCount>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrderStatusCount>> create(Ref ref) {
    return orderStatusCounts(ref);
  }
}

String _$orderStatusCountsHash() => r'66a1876568d315703e503ee2ef89f0dffd28eee4';

@ProviderFor(outstandingBalances)
const outstandingBalancesProvider = OutstandingBalancesProvider._();

final class OutstandingBalancesProvider extends $FunctionalProvider<
        AsyncValue<List<OutstandingBalance>>,
        List<OutstandingBalance>,
        FutureOr<List<OutstandingBalance>>>
    with
        $FutureModifier<List<OutstandingBalance>>,
        $FutureProvider<List<OutstandingBalance>> {
  const OutstandingBalancesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'outstandingBalancesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$outstandingBalancesHash();

  @$internal
  @override
  $FutureProviderElement<List<OutstandingBalance>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<OutstandingBalance>> create(Ref ref) {
    return outstandingBalances(ref);
  }
}

String _$outstandingBalancesHash() =>
    r'8731b6ab8c958400c32ebb94492cc5e9229a93f2';
