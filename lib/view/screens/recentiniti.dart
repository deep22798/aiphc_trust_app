import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/model/recentInitiativesList.dart';
import 'package:aiphc/model/recenthelp.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:aiphc/view/widgets/llivetimer.dart';
import 'package:aiphc/view/widgets/recent_initiative_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentHelp extends StatelessWidget {
  const RecentHelp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Globalcontroller());

    return Scaffold(
      appBar: CustomeAppBar(title: "Vittiya Sahayata"),

      body: Obx(() {
        if (controller.contactLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = 1;

            if (constraints.maxWidth >= 1200) {
              columns = 3;
            } else if (constraints.maxWidth >= 700) {
              columns = 2;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.65,
              ),
              itemCount: controller.recentiniti.length,
              itemBuilder: (context, index) {
                return SuccessGridCard(
                  data: controller.recentiniti[index],
                );
              },
            );
          },
        );
      }),
    );
  }
}

class SuccessGridCard extends StatelessWidget {
  final RecentInitiativeModel data;

  const SuccessGridCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Get.to(
              () => RecentInitiativeDetailScreen(data: data),
        );
      },
      child: Card(
        color: theme.cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                '${ServerAssets.baseUrl}admin/${data.image}',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              data.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            LiveTimer(startTime: data.dateCreated),
          ],
        ),
      ),
    );

  }
}
