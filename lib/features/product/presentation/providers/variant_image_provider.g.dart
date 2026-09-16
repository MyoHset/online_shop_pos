// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(variantImageRepository)
const variantImageRepositoryProvider = VariantImageRepositoryProvider._();

final class VariantImageRepositoryProvider extends $FunctionalProvider<
    VariantImageRepository,
    VariantImageRepository,
    VariantImageRepository> with $Provider<VariantImageRepository> {
  const VariantImageRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'variantImageRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$variantImageRepositoryHash();

  @$internal
  @override
  $ProviderElement<VariantImageRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VariantImageRepository create(Ref ref) {
    return variantImageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VariantImageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VariantImageRepository>(value),
    );
  }
}

String _$variantImageRepositoryHash() =>
    r'9f3b164fdc959413c0df8536000b47aa40b585d7';

@ProviderFor(VariantImageController)
const variantImageControllerProvider = VariantImageControllerProvider._();

final class VariantImageControllerProvider
    extends $NotifierProvider<VariantImageController, VariantImageState> {
  const VariantImageControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'variantImageControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$variantImageControllerHash();

  @$internal
  @override
  VariantImageController create() => VariantImageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VariantImageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VariantImageState>(value),
    );
  }
}

String _$variantImageControllerHash() =>
    r'f09e449e5fbd84383f7359b12b5e3d76385ad460';

abstract class _$VariantImageController extends $Notifier<VariantImageState> {
  VariantImageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VariantImageState, VariantImageState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<VariantImageState, VariantImageState>,
        VariantImageState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
