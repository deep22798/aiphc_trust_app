import 'package:aiphc/controllers/auth/login.dart';
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

class RecentHelp extends StatefulWidget {
  const RecentHelp({super.key});

  @override
  State<RecentHelp> createState() => _RecentHelpState();
}

class _RecentHelpState extends State<RecentHelp> {




  Widget _dateField(BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date",
          hintText: "YYYY-MM-DD",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          FocusScope.of(context).unfocus();

          DateTime initialDate = DateTime.now();

          if (controller.text.isNotEmpty) {
            try {
              initialDate = DateTime.parse(controller.text);
            } catch (_) {}
          }

          final pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            controller.text =
            "${pickedDate.year.toString().padLeft(4, '0')}-"
                "${pickedDate.month.toString().padLeft(2, '0')}-"
                "${pickedDate.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }
  void _openAddInitiativeSheet(BuildContext context) {
    final controller = Get.find<Globalcontroller>();
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
              () => SingleChildScrollView(
            child: Column(
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
                  "Add Recent Initiative",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // MAIN IMAGE
                GestureDetector(
                  onTap: controller.pickMainInitiativeImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      image: controller.mainImage.value != null
                          ? DecorationImage(
                        image:
                        FileImage(controller.mainImage.value!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: controller.mainImage.value == null
                        ? const Center(
                      child: Text("Tap to select main image"),
                    )
                        : null,
                  ),
                ),

                const SizedBox(height: 12),

                // MULTIPLE IMAGES
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: controller.pickMultipleInitiativeImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Add more images"),
                  ),
                ),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.multipleImages
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

                const SizedBox(height: 16),

                _input("Title", controller.titleCtrl),
                _input("Amount", controller.amountCtrl,
                    keyboard: TextInputType.number),
                _dateField(context, controller.dateCtrl),
                _input("Description", controller.descCtrl, maxLines: 3),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.initiativeUploading.value
                        ? null
                        : () async {
                      await controller.addRecentInitiative();
                     await controller.fetchsucesrecentini();
                    },
                    child: controller.initiativeUploading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "SAVE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
  Widget _input(
      String label,
      TextEditingController c, {
        int? maxLines,
        TextInputType keyboard = TextInputType.multiline,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: maxLines != null && maxLines > 1,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Globalcontroller());

    final authcontroller = Get.find<AuthController>();
    return Scaffold(
      appBar: CustomeAppBar(title: "Vittiya Sahayata (वित्तीय सहायता)"),
       floatingActionButton: authcontroller.enablerole.value == 2?SizedBox():  FloatingActionButton(
          onPressed: () {
            _openAddInitiativeSheet(context);
          },
          child: const Icon(Icons.add),
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
                '${ServerAssets.recent}${data.image}',
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
