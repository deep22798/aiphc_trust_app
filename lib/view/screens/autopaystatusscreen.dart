import 'package:aiphc/controllers/autopaystatuscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutopayStatusScreen extends StatelessWidget {

  final int memberId;

  const AutopayStatusScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(AutopayStatusController(memberId));

    return Scaffold(
      appBar: AppBar(title: const Text("Autopay Status")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            /// STATUS CARD
            Card(
              margin: const EdgeInsets.all(16),
              color: controller.autopayStatus.value == 'ACTIVE'
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              child: ListTile(
                leading: Icon(
                  controller.autopayStatus.value == 'ACTIVE'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: controller.autopayStatus.value == 'ACTIVE'
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(
                  "Autopay ${controller.autopayStatus.value}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                subtitle: controller.autopayStatus.value == 'ACTIVE'
                    ? Text(
                  "Last paid on ${controller.lastPaidDate.value} "
                      "₹${controller.lastAmount.value}",
                )
                    : const Text(
                  "Autopay is not active",
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Payment History",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            /// HISTORY LIST
            Expanded(
              child: ListView.builder(
                itemCount: controller.paymentHistory.length,
                itemBuilder: (context, index) {
                  final item =
                  controller.paymentHistory[index];

                  return ListTile(
                    leading: Icon(
                      item['status'] == 'SUCCESS'
                          ? Icons.check
                          : Icons.close,
                      color: item['status'] == 'SUCCESS'
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(
                        "₹${item['amount']}  (${item['month']}/${item['year']})"),
                    subtitle: Text(
                        "Txn: ${item['transaction_id'] ?? 'N/A'}"),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
