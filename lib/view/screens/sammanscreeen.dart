import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/model/ammanmodel.dart';
import 'package:aiphc/model/recentInitiativesList.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:aiphc/view/widgets/llivetimer.dart';
import 'package:aiphc/view/widgets/pensiondetailed.dart';
import 'package:aiphc/view/widgets/recent_initiative_detail_screen.dart';
import 'package:aiphc/view/widgets/sammandetaild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SammanHelpScreen extends StatefulWidget {
  const SammanHelpScreen({super.key});

  @override
  State<SammanHelpScreen> createState() => _SammanHelpScreenState();
}

class _SammanHelpScreenState extends State<SammanHelpScreen> {

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
  Widget _dateField(BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date",
          hintText: "YYYY-MM-DD",
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.text =
            "${picked.year.toString().padLeft(4, '0')}-"
                "${picked.month.toString().padLeft(2, '0')}-"
                "${picked.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }
  void _openAddSammanSheet(BuildContext context) {
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
                  "Add Samman Story",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                /// 🔹 MAIN IMAGE
                GestureDetector(
                  onTap: controller.pickPensionMainImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      image: controller.pensionMainImage.value != null
                          ? DecorationImage(
                        image: FileImage(
                            controller.pensionMainImage.value!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: controller.pensionMainImage.value == null
                        ? const Center(
                      child: Text("Tap to select main image"),
                    )
                        : null,
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔹 MULTIPLE IMAGES
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: controller.pickPensionMultipleImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Add more images"),
                  ),
                ),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.pensionImages
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
                  ).toList(),
                ),

                const SizedBox(height: 16),

                _input("Title", controller.pensionTitleCtrl),
                _input("Amount", controller.pensionAmountCtrl,
                    keyboard: TextInputType.number),
                _dateField(context, controller.pensionDateCtrl),
                _input("Description", controller.pensionDescCtrl, maxLines: 3),

                const SizedBox(height: 20),


                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.pensionUploading.value
                        ? null
                        : () async {
                      await controller.addSamman();
                      await controller.fetchsamman();
                    },
                    child: controller.pensionUploading.value
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



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Globalcontroller());



    final authcontroller = Get.find<AuthController>();
    return Scaffold(
      appBar: CustomeAppBar(title: "Samman Stories (सम्मान)"),
      floatingActionButton:
      authcontroller.enablerole.value != 1?SizedBox(): FloatingActionButton(
        onPressed: () {
          _openAddSammanSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await controller.fetchsamman();
        },
        child: Obx(() {
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
                itemCount: controller.sammanlist.length,
                itemBuilder: (context, index) {
                  return SammanHelpScreenGrid(
                    data: controller.sammanlist[index],
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}

class SammanHelpScreenGrid extends StatelessWidget {
  final SammanModel data;

  const SammanHelpScreenGrid({
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
              () => Sammandetailed(data: data),
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
                '${ServerAssets.pension}${data.image}',
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


class SammanHelpScreenGrid2 extends StatelessWidget {
  final SammanModel data;

  const SammanHelpScreenGrid2({
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
              () => Sammandetailed(data: data),
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
                '${ServerAssets.pension}${data.image}',
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              data.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,fontSize: 13
              ),
            ),


            const SizedBox(height: 8),

            // LiveTimer(startTime: data.dateCreated),
          ],
        ),
      ),
    );

  }
}
