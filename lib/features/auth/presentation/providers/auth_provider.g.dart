// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  const AuthRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'0d0e736444efdcb56551101de98c77696b007aa4';

@ProviderFor(AuthController)
const authControllerProvider = AuthControllerProvider._();

final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, ShopUser?> {
  const AuthControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'421e073603b8f02cc78152d03ca23cfda1df9d20';

abstract class _$AuthController extends $AsyncNotifier<ShopUser?> {
  FutureOr<ShopUser?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ShopUser?>, ShopUser?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ShopUser?>, ShopUser?>,
        AsyncValue<ShopUser?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(currentStaffRole)
const currentStaffRoleProvider = CurrentStaffRoleProvider._();

final class CurrentStaffRoleProvider extends $FunctionalProvider<
        AsyncValue<StaffRole>, StaffRole, FutureOr<StaffRole>>
    with $FutureModifier<StaffRole>, $FutureProvider<StaffRole> {
  const CurrentStaffRoleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentStaffRoleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentStaffRoleHash();

  @$internal
  @override
  $FutureProviderElement<StaffRole> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<StaffRole> create(Ref ref) {
    return currentStaffRole(ref);
  }
}

String _$currentStaffRoleHash() => r'8703c3d7e0d76b8481745ebe245330cc930a4731';
