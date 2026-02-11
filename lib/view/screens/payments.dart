import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/paymentcontroller.dart';
import 'package:aiphc/model/paymentmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/appbar.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {

  final PaymentsController paymentsController =
  Get.find<PaymentsController>();

  final AuthController authController =
  Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    paymentsController.fetchPayments(memberId: authController.usermodel.value?.id??""); // fetch all payments
    // paymentsController.fetchPayments(memberId: "1597");
  }

  // ✅ Month Number ➜ Month Name formatter
  String formatMonthYear(String month, String year) {
    final int m = int.tryParse(month) ?? 1;

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final String monthName =
    (m >= 1 && m <= 12) ? months[m - 1] : month;

    return "$monthName / $year";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(title: "Payments"),

      body: Obx(() {
        if (paymentsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (paymentsController.payments.isEmpty) {
          return const Center(child: Text("No payments found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: paymentsController.payments.length,
          itemBuilder: (context, index) {
            final Payment payment =
            paymentsController.payments[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => showPaymentDetails(payment),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                        payment.status == "SUCCESS"
                            ? Colors.green
                            : Colors.red,
                        child: const Icon(
                          Icons.payments,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹ ${payment.amount}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Order: ${payment.orderId}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                            Text(
                              formatMonthYear(
                                  payment.month, payment.year),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                      ),

                      Text(
                        payment.status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: payment.status == "SUCCESS"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // 🔥 PAYMENT DETAILS BOTTOM SHEET
  void showPaymentDetails(Payment payment) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Payment Details",
              style: Get.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _row("Amount", "₹ ${payment.amount}"),
            _row("Status", payment.status),
            _row("Order ID", payment.orderId),
            // _row("Transaction ID", payment.transactionId),
            _row(
              "Month / Year",
              formatMonthYear(payment.month, payment.year),
            ),
            _row("Payment Date", payment.date),
            // _row("Created At", payment.dateCreated),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text("CLOSE"),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 🔹 Reusable row widget
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: Get.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
