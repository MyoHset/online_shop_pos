// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerRemoteDataSource)
const customerRemoteDataSourceProvider = CustomerRemoteDataSourceProvider._();

final class CustomerRemoteDataSourceProvider extends $FunctionalProvider<
    CustomerRemoteDataSource,
    CustomerRemoteDataSource,
    CustomerRemoteDataSource> with $Provider<CustomerRemoteDataSource> {
  const CustomerRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customerRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customerRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CustomerRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CustomerRemoteDataSource create(Ref ref) {
    return customerRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRemoteDataSource>(value),
    );
  }
}

String _$customerRemoteDataSourceHash() =>
    r'fb86e3f959b6f6f069dad87dcb3894780631308c';

@ProviderFor(customerRepository)
const customerRepositoryProvider = CustomerRepositoryProvider._();

final class CustomerRepositoryProvider extends $FunctionalProvider<
    CustomerRepository,
    CustomerRepository,
    CustomerRepository> with $Provider<CustomerRepository> {
  const CustomerRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customerRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'ae294f007e64a9f6fb89a3f827577aed534fdc73';

/// Query for filtering customers by name or phone

@ProviderFor(CustomerSearchQuery)
const customerSearchQueryProvider = CustomerSearchQueryProvider._();

/// Query for filtering customers by name or phone
final class CustomerSearchQueryProvider
    extends $NotifierProvider<CustomerSearchQuery, String> {
  /// Query for filtering customers by name or phone
  const CustomerSearchQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customerSearchQueryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customerSearchQueryHash();

  @$internal
  @override
  CustomerSearchQuery create() => CustomerSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$customerSearchQueryHash() =>
    r'7554dcd5793a1a73b7574363f3fbbc2d9d21d381';

/// Query for filtering customers by name or phone

abstract class _$CustomerSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Provides filtered or full list of customers

@ProviderFor(CustomerList)
const customerListProvider = CustomerListProvider._();

/// Provides filtered or full list of customers
final class CustomerListProvider
    extends $AsyncNotifierProvider<CustomerList, List<Customer>> {
  /// Provides filtered or full list of customers
  const CustomerListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customerListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customerListHash();

  @$internal
  @override
  CustomerList create() => CustomerList();
}

String _$customerListHash() => r'96844b134fdccbbe79a974d548e5e645fff23088';

/// Provides filtered or full list of customers

abstract class _$CustomerList extends $AsyncNotifier<List<Customer>> {
  FutureOr<List<Customer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Customer>>, List<Customer>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Customer>>, List<Customer>>,
        AsyncValue<List<Customer>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Provides single customer by ID

@ProviderFor(customerDetail)
const customerDetailProvider = CustomerDetailFamily._();

/// Provides single customer by ID

final class CustomerDetailProvider extends $FunctionalProvider<
        AsyncValue<Customer>, Customer, FutureOr<Customer>>
    with $FutureModifier<Customer>, $FutureProvider<Customer> {
  /// Provides single customer by ID
  const CustomerDetailProvider._(
      {required CustomerDetailFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'customerDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customerDetailHash();

  @override
  String toString() {
    return r'customerDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Customer> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Customer> create(Ref ref) {
    final argument = this.argument as String;
    return customerDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerDetailHash() => r'f7c8163abbffc8ac2b9bd1b57198a7c15f68a641';

/// Provides single customer by ID

final class CustomerDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Customer>, String> {
  const CustomerDetailFamily._()
      : super(
          retry: null,
          name: r'customerDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provides single customer by ID

  CustomerDetailProvider call(
    String id,
  ) =>
      CustomerDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'customerDetailProvider';
}

/// Provides ledger transaction history for a customer

@ProviderFor(CustomerTransactions)
const customerTransactionsProvider = CustomerTransactionsFamily._();

/// Provides ledger transaction history for a customer
final class CustomerTransactionsProvider extends $AsyncNotifierProvider<
    CustomerTransactions, List<CustomerTransaction>> {
  /// Provides ledger transaction history for a customer
  const CustomerTransactionsProvider._(
      {required CustomerTransactionsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'customerTransactionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customerTransactionsHash();

  @override
  String toString() {
    return r'customerTransactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerTransactions create() => CustomerTransactions();

  @override
  bool operator ==(Object other) {
    return other is CustomerTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerTransactionsHash() =>
    r'15479c0a54a1a4161a4a579a23df021e1ac161fa';

/// Provides ledger transaction history for a customer

final class CustomerTransactionsFamily extends $Family
    with
        $ClassFamilyOverride<
            CustomerTransactions,
            AsyncValue<List<CustomerTransaction>>,
            List<CustomerTransaction>,
            FutureOr<List<CustomerTransaction>>,
            String> {
  const CustomerTransactionsFamily._()
      : super(
          retry: null,
          name: r'customerTransactionsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provides ledger transaction history for a customer

  CustomerTransactionsProvider call(
    String customerId,
  ) =>
      CustomerTransactionsProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerTransactionsProvider';
}

/// Provides ledger transaction history for a customer

abstract class _$CustomerTransactions
    extends $AsyncNotifier<List<CustomerTransaction>> {
  late final _$args = ref.$arg as String;
  String get customerId => _$args;

  FutureOr<List<CustomerTransaction>> build(
    String customerId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<CustomerTransaction>>,
        List<CustomerTransaction>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<CustomerTransaction>>,
            List<CustomerTransaction>>,
        AsyncValue<List<CustomerTransaction>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Controller for Customer mutations (Create, Update, Repayment)

@ProviderFor(CustomerController)
const customerControllerProvider = CustomerControllerProvider._();

/// Controller for Customer mutations (Create, Update, Repayment)
final class CustomerControllerProvider
    extends $NotifierProvider<CustomerController, AsyncValue<void>> {
  /// Controller for Customer mutations (Create, Update, Repayment)
  const CustomerControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customerControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customerControllerHash();

  @$internal
  @override
  CustomerController create() => CustomerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$customerControllerHash() =>
    r'b297a109201455a55ff8491e0fb9e98c5a6e796d';

/// Controller for Customer mutations (Create, Update, Repayment)

abstract class _$CustomerController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
