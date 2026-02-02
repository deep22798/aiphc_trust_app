
import 'package:aiphc/model/pensionhelp.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:aiphc/view/widgets/llivetimer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'full_screen_image.dart';

class PensionDetailScreen extends StatelessWidget {
  final PensionHelpModel data;

  const PensionDetailScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomeAppBar(title: data.title),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 MAIN IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                '${ServerAssets.baseUrl}admin/${data.image}',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 TITLE
            Text(
              data.title,
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
                  data.amount,
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
                  data.date,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 LIVE TIMER
            LiveTimer(startTime: data.dateCreated),

            const SizedBox(height: 20),

            /// 🔹 DESCRIPTION (HTML)
            Html(
              data: data.pageDescription,
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
            if (data.images.isNotEmpty) ...[
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
                itemCount: data.images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final img = data.images[index];
                  final fullUrl = '${ServerAssets.baseUrl}admin/$img';
                  final heroTag = 'gallery_${data.id}_$index';

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
