// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(staffRepository)
const staffRepositoryProvider = StaffRepositoryProvider._();

final class StaffRepositoryProvider extends $FunctionalProvider<StaffRepository,
    StaffRepository, StaffRepository> with $Provider<StaffRepository> {
  const StaffRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'staffRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$staffRepositoryHash();

  @$internal
  @override
  $ProviderElement<StaffRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StaffRepository create(Ref ref) {
    return staffRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffRepository>(value),
    );
  }
}

String _$staffRepositoryHash() => r'8f066b5efa5a459d685cd11c881372fe46529667';

@ProviderFor(StaffListController)
const staffListControllerProvider = StaffListControllerProvider._();

final class StaffListControllerProvider
    extends $AsyncNotifierProvider<StaffListController, List<StaffMember>> {
  const StaffListControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'staffListControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$staffListControllerHash();

  @$internal
  @override
  StaffListController create() => StaffListController();
}

String _$staffListControllerHash() =>
    r'70dac36d96be302818ee7d22accc35a541e50231';

abstract class _$StaffListController extends $AsyncNotifier<List<StaffMember>> {
  FutureOr<List<StaffMember>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<StaffMember>>, List<StaffMember>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<StaffMember>>, List<StaffMember>>,
        AsyncValue<List<StaffMember>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
