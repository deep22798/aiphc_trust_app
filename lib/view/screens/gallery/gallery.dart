import 'package:aiphc/controllers/screens/gallery.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/view/screens/gallery/gallery_images_screen.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GalleryController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomeAppBar(title: "Gallery"),

      body: Obx(() {
        if (controller.albumLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (controller.gallery.isEmpty) {
          return Center(
            child: Text(
              'कोई गैलरी उपलब्ध नहीं है',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: controller.gallery.length,
          itemBuilder: (context, index) {
            final album = controller.gallery[index];

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Get.to(
                      () => GalleryImagesScreen(
                    albumId: album.id,
                    albumTitle: album.title,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          ServerAssets.gallery + album.coverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        album.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
