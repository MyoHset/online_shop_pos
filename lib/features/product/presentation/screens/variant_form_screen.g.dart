// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_form_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(createVariantUseCase)
const createVariantUseCaseProvider = CreateVariantUseCaseProvider._();

final class CreateVariantUseCaseProvider
    extends $FunctionalProvider<CreateVariant, CreateVariant, CreateVariant>
    with $Provider<CreateVariant> {
  const CreateVariantUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'createVariantUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$createVariantUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateVariant> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateVariant create(Ref ref) {
    return createVariantUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateVariant value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateVariant>(value),
    );
  }
}

String _$createVariantUseCaseHash() =>
    r'6f8a982c43bb07b5950938b6a551999c0bce0736';

@ProviderFor(updateVariantUseCase)
const updateVariantUseCaseProvider = UpdateVariantUseCaseProvider._();

final class UpdateVariantUseCaseProvider
    extends $FunctionalProvider<UpdateVariant, UpdateVariant, UpdateVariant>
    with $Provider<UpdateVariant> {
  const UpdateVariantUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateVariantUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateVariantUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateVariant> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateVariant create(Ref ref) {
    return updateVariantUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateVariant value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateVariant>(value),
    );
  }
}

String _$updateVariantUseCaseHash() =>
    r'93617804124042262fae62242f7652c11ac35423';
