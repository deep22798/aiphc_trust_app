import 'package:aiphc/controllers/screens/gallery.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryImagesScreen extends StatefulWidget {
  final String albumId;
  final String albumTitle;

  const GalleryImagesScreen({
    super.key,
    required this.albumId,
    required this.albumTitle,
  });

  @override
  State<GalleryImagesScreen> createState() => _GalleryImagesScreenState();
}

class _GalleryImagesScreenState extends State<GalleryImagesScreen> {
  final controller = Get.put(GalleryController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchGalleryimages(widget.albumId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar:  CustomeAppBar(title: "${widget.albumTitle}"),

      body: Obx(() {
        if (controller.imageLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (controller.galleryimages.isEmpty) {
          return Center(
            child: Text(
              'इस एल्बम में कोई फोटो नहीं है',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.galleryimages.length,
          itemBuilder: (context, index) {
            final image = controller.galleryimages[index];
            final imageUrl = ServerAssets.gallery + image.image;

            return GestureDetector(
              onTap: () {
                Get.to(() => FullImageViewer(imageUrl: imageUrl));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class FullImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullImageViewer({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.broken_image,
                    color: theme.colorScheme.onSurface,
                    size: 60),
          ),
        ),
      ),
    );
  }
}
