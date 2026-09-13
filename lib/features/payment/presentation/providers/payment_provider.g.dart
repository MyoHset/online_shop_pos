// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentRemoteDataSource)
const paymentRemoteDataSourceProvider = PaymentRemoteDataSourceProvider._();

final class PaymentRemoteDataSourceProvider extends $FunctionalProvider<
    PaymentRemoteDataSource,
    PaymentRemoteDataSource,
    PaymentRemoteDataSource> with $Provider<PaymentRemoteDataSource> {
  const PaymentRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paymentRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paymentRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PaymentRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentRemoteDataSource create(Ref ref) {
    return paymentRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentRemoteDataSource>(value),
    );
  }
}

String _$paymentRemoteDataSourceHash() =>
    r'8f47ca343790054ddc8e478cee398f86149ae3f0';

@ProviderFor(paymentRepository)
const paymentRepositoryProvider = PaymentRepositoryProvider._();

final class PaymentRepositoryProvider extends $FunctionalProvider<
    PaymentRepository,
    PaymentRepository,
    PaymentRepository> with $Provider<PaymentRepository> {
  const PaymentRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paymentRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paymentRepositoryHash();

  @$internal
  @override
  $ProviderElement<PaymentRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentRepository create(Ref ref) {
    return paymentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentRepository>(value),
    );
  }
}

String _$paymentRepositoryHash() => r'894a40b9b7a45247bb75af5301ff6307f70265bb';

@ProviderFor(getPaymentsForOrderUseCase)
const getPaymentsForOrderUseCaseProvider =
    GetPaymentsForOrderUseCaseProvider._();

final class GetPaymentsForOrderUseCaseProvider extends $FunctionalProvider<
    GetPaymentsForOrder,
    GetPaymentsForOrder,
    GetPaymentsForOrder> with $Provider<GetPaymentsForOrder> {
  const GetPaymentsForOrderUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getPaymentsForOrderUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getPaymentsForOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPaymentsForOrder> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetPaymentsForOrder create(Ref ref) {
    return getPaymentsForOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPaymentsForOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPaymentsForOrder>(value),
    );
  }
}

String _$getPaymentsForOrderUseCaseHash() =>
    r'f80e5a87422d268048ec8c87b87f2bee85b0f8fc';

@ProviderFor(recordPaymentUseCase)
const recordPaymentUseCaseProvider = RecordPaymentUseCaseProvider._();

final class RecordPaymentUseCaseProvider
    extends $FunctionalProvider<RecordPayment, RecordPayment, RecordPayment>
    with $Provider<RecordPayment> {
  const RecordPaymentUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recordPaymentUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recordPaymentUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecordPayment> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecordPayment create(Ref ref) {
    return recordPaymentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordPayment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordPayment>(value),
    );
  }
}

String _$recordPaymentUseCaseHash() =>
    r'671ffd007503ece8971f53c621762834c04870d2';

@ProviderFor(updatePaymentStatusUseCase)
const updatePaymentStatusUseCaseProvider =
    UpdatePaymentStatusUseCaseProvider._();

final class UpdatePaymentStatusUseCaseProvider extends $FunctionalProvider<
    UpdatePaymentStatus,
    UpdatePaymentStatus,
    UpdatePaymentStatus> with $Provider<UpdatePaymentStatus> {
  const UpdatePaymentStatusUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updatePaymentStatusUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updatePaymentStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdatePaymentStatus> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdatePaymentStatus create(Ref ref) {
    return updatePaymentStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdatePaymentStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdatePaymentStatus>(value),
    );
  }
}

String _$updatePaymentStatusUseCaseHash() =>
    r'e4acb469e6b501efbce291b52e69cfe6580e9ce9';

/// Provides all payments for a given order — family + autoDispose.

@ProviderFor(OrderPayments)
const orderPaymentsProvider = OrderPaymentsFamily._();

/// Provides all payments for a given order — family + autoDispose.
final class OrderPaymentsProvider
    extends $AsyncNotifierProvider<OrderPayments, List<Payment>> {
  /// Provides all payments for a given order — family + autoDispose.
  const OrderPaymentsProvider._(
      {required OrderPaymentsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'orderPaymentsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderPaymentsHash();

  @override
  String toString() {
    return r'orderPaymentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderPayments create() => OrderPayments();

  @override
  bool operator ==(Object other) {
    return other is OrderPaymentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderPaymentsHash() => r'620ab17ebda5b5216cdd04c29ecff94f9d6963d7';

/// Provides all payments for a given order — family + autoDispose.

final class OrderPaymentsFamily extends $Family
    with
        $ClassFamilyOverride<OrderPayments, AsyncValue<List<Payment>>,
            List<Payment>, FutureOr<List<Payment>>, String> {
  const OrderPaymentsFamily._()
      : super(
          retry: null,
          name: r'orderPaymentsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provides all payments for a given order — family + autoDispose.

  OrderPaymentsProvider call(
    String orderId,
  ) =>
      OrderPaymentsProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderPaymentsProvider';
}

/// Provides all payments for a given order — family + autoDispose.

abstract class _$OrderPayments extends $AsyncNotifier<List<Payment>> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<List<Payment>> build(
    String orderId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Payment>>, List<Payment>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Payment>>, List<Payment>>,
        AsyncValue<List<Payment>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
