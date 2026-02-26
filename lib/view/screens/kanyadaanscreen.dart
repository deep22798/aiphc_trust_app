import 'package:aiphc/controllers/screens/dashboardcontroller.dart';
import 'package:aiphc/view/screens/verifidkanyadaan.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/routes/serverassets.dart';

class KanyadaanMembersScreen extends StatelessWidget {
  const KanyadaanMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomeAppBar(title: "Kanyadaan Members (कन्यादान सदस्य)"),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.members.isEmpty) {
          return const Center(child: Text("No Kanyadaan Members Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.members.length,
          itemBuilder: (context, index) {
            final m = controller.members[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: m.userPhoto.isNotEmpty
                            ? NetworkImage(
                          ServerAssets.baseUrl +
                              "uploads/member/" +
                              m.userPhoto,
                        )
                            : null,
                        child: m.userPhoto.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.name,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${m.district}, ${m.state}",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      /// STATUS CHIP
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: m.kanyadaan == "2"
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          m.kanyadaan == "2" ? "Verified" : "Pending",
                          style: TextStyle(
                            color: m.kanyadaan == "2"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(),

                  _row("Mobile", m.mobile),
                  _row("Daughter", m.daughterName),
                  _row("Daughter Mobile", m.daughterMobile),
                  _row("Bank", m.bankName),
                  _row("Account", m.accountNo),
                  _row("IFSC", m.ifsc),

                  const SizedBox(height: 12),

                  /// SWITCH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Verify Kanyadaan",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      Switch(
                        value: m.kanyadaan == "2",
                        activeColor: Colors.green,
                        onChanged: (val) {
                          controller.updateKanyadaanStatus(
                            memberId: m.id,
                            kanyadaan: val ? "2" : "1",
                          );
                        },

                      ),
                      InkWell(
                          onTap: (){Get.to(()=>Verifidkanyadaan(memberId: m.id));},
                          child: Container(
                              decoration: BoxDecoration(color: Colors.orange.shade50,borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20,right: 20,top: 8,bottom: 8),
                                child: Text("Open",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              )))
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }
}



