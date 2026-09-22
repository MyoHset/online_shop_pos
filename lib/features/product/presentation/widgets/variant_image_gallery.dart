import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/variant_images_provider.dart';
import 'product_image_placeholder.dart';
import 'product_image_loading_indicator.dart';

class VariantImageGallery extends ConsumerStatefulWidget {
  const VariantImageGallery({super.key, required this.variantId});
  final String variantId;

  @override
  ConsumerState<VariantImageGallery> createState() => _VariantImageGalleryState();
}

class _VariantImageGalleryState extends ConsumerState<VariantImageGallery> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void didUpdateWidget(VariantImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variantId != widget.variantId) {
      _selectedIndex = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagesAsync = ref.watch(variantImagesProvider(widget.variantId));

    return imagesAsync.when(
      loading: () => const AspectRatio(
        aspectRatio: 1,
        child: ProductImageLoadingIndicator(),
      ),
      error: (_, __) => const AspectRatio(
        aspectRatio: 1,
        child: ProductImagePlaceholder(),
      ),
      data: (images) {
        if (images.isEmpty) {
          return const AspectRatio(
            aspectRatio: 1,
            child: ProductImagePlaceholder(),
          );
        }
        
        final isMobile = context.isMobile;

        if (isMobile) {
          return AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (idx) => setState(() => _selectedIndex = idx),
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index].imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                          progress == null ? child : const ProductImageLoadingIndicator(),
                      errorBuilder: (_, __, ___) => const ProductImagePlaceholder(),
                    );
                  },
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedIndex == index
                                ? AppColors.slate900
                                : Colors.white.withAlpha(128),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        // Tablet/Desktop
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images[_selectedIndex].imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const ProductImageLoadingIndicator(),
                  errorBuilder: (_, __, ___) => const ProductImagePlaceholder(),
                ),
              ),
            ),
            if (images.length > 1) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppColors.slate900 : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            images[index].imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) =>
                                progress == null ? child : const ProductImageLoadingIndicator(),
                            errorBuilder: (_, __, ___) => const ProductImagePlaceholder(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
