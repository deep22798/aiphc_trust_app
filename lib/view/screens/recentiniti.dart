import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/model/recentInitiativesList.dart';
import 'package:aiphc/model/recenthelp.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:aiphc/view/widgets/llivetimer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentHelp extends StatelessWidget {
  const RecentHelp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Globalcontroller());

    return Scaffold(
      appBar: AppBar(
        title: const Text('वित्तीय सहायता'),
        centerTitle: true,
      ),

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

    return Card(
      color: theme.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// IMAGE
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
        
            const SizedBox(height: 12),
        
            /// TITLE
            Text(
              data.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
        
            // const SizedBox(height: 12),
        
            /// LIVE TIMER
            LiveTimer(startTime: data.dateCreated),
        
            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
