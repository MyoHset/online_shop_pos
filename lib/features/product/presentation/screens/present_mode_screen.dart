import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/browse_for_customer_provider.dart';
import '../widgets/present_mode_grid.dart';

class PresentModeScreen extends ConsumerWidget {
  const PresentModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(browseResultsProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Dark/Immersive background for present mode
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        bottom: false,
        child: resultsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'No items available.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            return PresentModeGrid(items: items);
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
          error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}
