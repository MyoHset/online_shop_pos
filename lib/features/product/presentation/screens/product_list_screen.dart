import 'package:flutter/material.dart';
import '../../../../core/responsive/device_type.dart';
import '../views/product_list_views.dart';

/// Product list screen — delegates to the correct layout variant based on
/// [DeviceType]. Business logic and state live in the shared Riverpod
/// providers; only presentation differs between variants.
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (DeviceType.from(context)) {
      DeviceType.mobile => const ProductListMobileView(),
      DeviceType.tablet => const ProductListTabletView(),
      DeviceType.desktop || DeviceType.large => const ProductListDesktopView(),
    };
  }
}
