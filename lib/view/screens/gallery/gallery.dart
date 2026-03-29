import 'package:aiphc/controllers/auth/login.dart';
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

    final authcontroller = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomeAppBar(title: "Gallery (गैलरी)"),

      body: RefreshIndicator(
        onRefresh: ()async{
          await controller.fetchGallery();
        },
        child: Obx(() {
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
      ),

      floatingActionButton:authcontroller.enablerole.value != 1?SizedBox(): FloatingActionButton(
      onPressed: () {
        _openAddAlbumSheet(context);
      },
      child: const Icon(Icons.add),
    ),

    );
  }
  void _openAddAlbumSheet(BuildContext context) {
    final controller = Get.put(GalleryController());

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
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
                "Add Gallery Album",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // Cover Image Picker
              GestureDetector(
                onTap: controller.pickCoverImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    image: controller.coverImage.value != null
                        ? DecorationImage(
                      image: FileImage(controller.coverImage.value!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: controller.coverImage.value == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image, size: 42),
                      SizedBox(height: 6),
                      Text("Tap to select cover image"),
                    ],
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              // Album Title
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: "Album Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.loading.value
                      ? null
                      : () async {
                    await controller.addAlbum();
                    controller.fetchGallery(); // 🔥 refresh gallery
                  },
                  child: controller.loading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "CREATE ALBUM",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
