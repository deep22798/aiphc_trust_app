import 'dart:math' as math;

import 'package:aiphc/controllers/auth/login.dart';
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

  final authcontroller = Get.find<AuthController>();

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


      floatingActionButton: authcontroller.enablerole.value != 1?SizedBox(): FloatingActionButton(
        onPressed: () {
          _openAddImageSheet(context);
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  void _openAddImageSheet(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const Text(
                "Add Image to Album",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // Image Picker
              GestureDetector(
                onTap: controller.pickGalleryImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    image: controller.selectedGalleryImage.value != null
                        ? DecorationImage(
                      image: FileImage(
                          controller.selectedGalleryImage.value!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: controller.selectedGalleryImage.value == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image, size: 44),
                      SizedBox(height: 6),
                      Text("Tap to select image"),
                    ],
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.imageUploading.value
                      ? null
                      : () async {
                    await controller.addGalleryImage(widget.albumId);
                    controller.fetchGalleryimages(widget.albumId);
                  },
                  child: controller.imageUploading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "UPLOAD IMAGE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

}

class FullImageViewer extends StatefulWidget {
  final String imageUrl;

  const FullImageViewer({
    super.key,
    required this.imageUrl,
  });

  @override
  State<FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<FullImageViewer> {
  final TransformationController _controller = TransformationController();

  double _rotation = 0;

  void _zoomIn() {
    _controller.value = _controller.value.scaled(1.2);
  }

  void _zoomOut() {
    _controller.value = _controller.value.scaled(0.8);
  }

  void _reset() {
    _controller.value = Matrix4.identity();

    setState(() {
      _rotation = 0;
    });
  }

  void _rotateImage() {
    setState(() {
      _rotation += math.pi / 2; // 90 degree
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _rotateImage,
            icon: const Icon(Icons.rotate_right),
          ),
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 1,
              maxScale: 5,
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(100),
              child: Center(
                child: Transform.rotate(
                  angle: _rotation,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                        ) {
                      if (loadingProgress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 70,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}