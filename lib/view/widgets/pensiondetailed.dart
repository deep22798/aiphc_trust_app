
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/model/pensionhelp.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:aiphc/view/widgets/llivetimer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'full_screen_image.dart';

class PensionDetailScreen extends StatefulWidget {
  final PensionHelpModel data;

  const PensionDetailScreen({
    super.key,
    required this.data,
  });

  @override
  State<PensionDetailScreen> createState() => _PensionDetailScreenState();
}

class _PensionDetailScreenState extends State<PensionDetailScreen> {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void _openAddMorePensionImagesSheet(BuildContext context, String pensionId) {

      final controller = Get.put(Globalcontroller());
      final theme = Theme.of(context);

      // VERY IMPORTANT – clear old selection
      controller.imagess.clear();

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
                  "Add More Images",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // PICK IMAGES
                GestureDetector(
                  onTap: controller.pickImagess,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text("Tap to select images"),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.imagess
                      .map(
                        (img) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        img,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      .toList(),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.uploadingg.value
                        ? null
                        : () async {
                      await controller.uploadImagess(pensionId);
                      await controller.fetchsucespension();
                    },
                    child: controller.uploadingg.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "UPLOAD",
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

    return Scaffold(
      appBar: CustomeAppBar(title: widget.data.title),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddMorePensionImagesSheet(context, widget.data.id);
        },
        child: const Icon(Icons.add_photo_alternate),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 MAIN IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                '${ServerAssets.pension}${widget.data.image}',
                width: double.infinity,
                fit: BoxFit.cover,height: 300,
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 TITLE
            Text(
              widget.data.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// 🔹 AMOUNT
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 18),
                const SizedBox(width: 4),
                Text(
                  widget.data.amount,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔹 DATE
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text(
                  widget.data.date,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 LIVE TIMER
            LiveTimer(startTime: widget.data.dateCreated),

            const SizedBox(height: 20),

            /// 🔹 DESCRIPTION (HTML)
            Html(
              data: widget.data.pageDescription,
              style: {
                "body": Style(
                  fontSize: FontSize(16),
                  lineHeight: const LineHeight(1.6),
                  color: theme.textTheme.bodyMedium?.color,
                ),
              },
            ),

            const SizedBox(height: 24),

            /// 🔹 IMAGE GALLERY
            if (widget.data.images.isNotEmpty) ...[
              Text(
                'Gallery',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.data.images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final img = widget.data.images[index];
                  final fullUrl = '${ServerAssets.pension}$img';
                  final heroTag = 'gallery_${widget.data.id}_$index';

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) => FullScreenImage(
                            imageUrl: fullUrl,
                            tag: heroTag,

                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          fullUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),

            ],
          ],
        ),
      ),
    );
  }
}
