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
      String? brand,
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
        String? brand,
        String? category,
        String search,
      }) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<
          ({
            String? brand,
            String? category,
            String search,
          })>(value),
    );
  }
}

String _$orderItemPickerFilterHash() =>
    r'c62732c2dd933dec73170d847178bf70de2f4b83';

abstract class _$OrderItemPickerFilter extends $Notifier<
    ({
      String? brand,
      String? category,
      String search,
    })> {
  ({
    String? brand,
    String? category,
    String search,
  }) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        ({
          String? brand,
          String? category,
          String search,
        }),
        ({
          String? brand,
          String? category,
          String search,
        })>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<
            ({
              String? brand,
              String? category,
              String search,
            }),
            ({
              String? brand,
              String? category,
              String search,
            })>,
        ({
          String? brand,
          String? category,
          String search,
        }),
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
