// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_picker_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderItemPickerFilter)
const orderItemPickerFilterProvider = OrderItemPickerFilterProvider._();

final class OrderItemPickerFilterProvider extends $NotifierProvider<
    OrderItemPickerFilter,
    ({
      String? category,
      String search,
    })> {
  const OrderItemPickerFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'orderItemPickerFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderItemPickerFilterHash();

  @$internal
  @override
  OrderItemPickerFilter create() => OrderItemPickerFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
      ({
        String? category,
        String search,
      }) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<
          ({
            String? category,
            String search,
          })>(value),
    );
  }
}

String _$orderItemPickerFilterHash() =>
    r'c179b19045c528a6997069c45dd8356b6df830cd';

abstract class _$OrderItemPickerFilter extends $Notifier<
    ({
      String? category,
      String search,
    })> {
  ({
    String? category,
    String search,
  }) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        ({
          String? category,
          String search,
        }),
        ({
          String? category,
          String search,
        })>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<
            ({
              String? category,
              String search,
            }),
            ({
              String? category,
              String search,
            })>,
        ({
          String? category,
          String search,
        }),
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
