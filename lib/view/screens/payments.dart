import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/controllers/paymentcontroller.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
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
  final PaymentsController paymentsController = Get.find();
  final Globalcontroller globalcontroller = Get.find();
  final AuthController authController = Get.find();
  final PhonePeController phonePeAuthController = Get.find();

  @override
  void initState() {
    super.initState();
    paymentsController.fetchPayments(
        memberId: authController.usermodel.value?.id ?? "");
  }

  /// Month formatter
  String formatMonthYear(String month, String year) {
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
    final m = int.tryParse(month) ?? 1;
    return "${months[m - 1]} / $year";
  }

  /// MOP Color
  Color mopColor(String mop) {
    switch (mop.toLowerCase()) {
      case 'upi':
        return Colors.deepPurple;
      case 'pg':
        return Colors.blue;
      case 'cash':
        return Colors.green;
      case 'bank':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// MOP Icon
  IconData mopIcon(String mop) {
    switch (mop.toLowerCase()) {
      case 'upi':
        return Icons.account_balance_wallet;
      case 'pg':
        return Icons.payment;
      case 'cash':
        return Icons.money;
      case 'bank':
        return Icons.account_balance;
      default:
        return Icons.receipt_long;
    }
  }

  /// ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(title: "Payments"),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: _showPaymentPopup,
        label: const Text("Add Payment",style: TextStyle(color: Colors.white,),),
        icon: const Icon(Icons.add,color: Colors.white,),
      ),
      body: Obx(() {
        if (paymentsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (paymentsController.payments.isEmpty) {
          return const Center(child: Text("No payments found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: paymentsController.payments.length,
          itemBuilder: (context, index) {
            final Payment payment = paymentsController.payments[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Get.theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => showPaymentDetails(payment),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// STATUS ICON
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: payment.status == "SUCCESS"
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                        ),
                        child: Icon(
                          Icons.payments,
                          color: payment.status == "SUCCESS"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// MAIN CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "₹ ${payment.amount}",
                                  style: Get.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                _statusChip(payment.status),
                              ],
                            ),

                            const SizedBox(height: 6),
                            Text(
                              "Order ID: ${payment.orderId}",
                              style: Get.textTheme.bodySmall,
                            ),

                            const SizedBox(height: 4),
                            Text(
                              formatMonthYear(
                                  payment.month, payment.year),
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),

                            const SizedBox(height: 10),

                            /// MOP BADGE
                Obx(()=>authController.enablerole.value.toString()!="1"?SizedBox():Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: mopColor(payment.mop)
                                    .withOpacity(0.15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    mopIcon(payment.mop),
                                    size: 14,
                                    color: mopColor(payment.mop),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    payment.mop.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: mopColor(payment.mop),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
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

  /// STATUS CHIP
  Widget _statusChip(String status) {
    final isSuccess = status == "SUCCESS";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSuccess
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSuccess ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  /// ---------------- PAYMENT DETAILS ----------------

  void showPaymentDetails(Payment payment) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(20)),
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
            Obx(()=>authController.enablerole.value.toString()!="1"?SizedBox():_row("Mode", payment.mop.toUpperCase()),),
            _row("Month / Year",
                formatMonthYear(payment.month, payment.year)),
            _row("Date", payment.date),
            const SizedBox(height: 10),
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

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: Get.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }

  /// ---------------- PAYMENT POPUP (UNCHANGED LOGIC) ----------------
  void _showPaymentPopup() {
    Get.bottomSheet(
      SafeArea(
        child: DefaultTabController(
          length: 1,
          child: Container(
            height: Get.height * 0.75,
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// DRAG HANDLE
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Complete Payment",
                  style: Get.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                /// TABS
                Column(
                  children: [
                    TabBar(
                      indicatorColor: Get.theme.primaryColor,
                      labelColor: Get.theme.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: "Pay Now"),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// TAB VIEWS
                Obx(()=> authController.isLoading.value==true?Center(child: Container(child: CircularProgressIndicator())): Expanded(
                  child: TabBarView(
                    children: [
                      _upiPaymentTab(),
                    ],
                  ),
                ),),

              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
  Widget _upiPaymentTab() {
    final RxInt selectedAmount = 100.obs;
    final TextEditingController amountController =
    TextEditingController(text: '100');

    /// 🔥 Added 100 here
    final List<int> suggestedAmounts = [100, 500, 1000, 2000, 5000];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Amount title
            Text(
              "Enter Amount",
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            /// Amount input (read-only)
            TextField(
              controller: amountController,
              enabled: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "₹ ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Suggested amounts
            Text(
              "Quick Select",
              style: Get.textTheme.titleSmall,
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: suggestedAmounts.map((amount) {
                return Obx(
                      () => ChoiceChip(
                    label: Text("₹$amount"),
                    selected: selectedAmount.value == amount,
                    onSelected: (_) {
                      selectedAmount.value = amount;
                      amountController.text = amount.toString();
                    },
                    selectedColor: Get.theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selectedAmount.value == amount
                          ? Colors.white
                          : Get.theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            /// Proceed button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                    () => ElevatedButton(
                  onPressed: () async{
                    final payAmount = selectedAmount.value;
                    print("Proceed to pay ₹$payAmount");
                    // startUpiPayment(payAmount);
                    await phonePeAuthController.startTransaction(payAmount);

                    if(phonePeAuthController.paymentsuccess.value.toString()=="1"){
                        await phonePeAuthController.uploadPaymentData( amount: payAmount.toString(), orderId: phonePeAuthController.orderid.toString(), transactionId: phonePeAuthController.orderid.value.toString(), status: phonePeAuthController.paymentstatus.value.toString(),aadhar: authController.usermodel.value?.aadhar.toString()??"",screenshotPhoto: '', mop: 'pg');
                    await paymentsController.fetchPayments(memberId: authController.usermodel.value?.id.toString()??"");
                        Get.back();
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Proceed to Pay ₹${selectedAmount.value} ",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // void _showPaymentPopup() {
  //   Get.bottomSheet(
  //     SafeArea(
  //       child: DefaultTabController(
  //         length: 1,
  //         child: Container(
  //           height: Get.height * 0.78,
  //           decoration: BoxDecoration(
  //             borderRadius: const BorderRadius.vertical(
  //               top: Radius.circular(30),
  //             ),
  //             gradient: LinearGradient(
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //               colors: [
  //                 Get.theme.colorScheme.primary.withOpacity(0.08),
  //                 Get.theme.scaffoldBackgroundColor,
  //               ],
  //             ),
  //           ),
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 12),
  //
  //               /// DRAG HANDLE
  //               Container(
  //                 width: 60,
  //                 height: 6,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade400,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               /// TITLE
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(Icons.lock, size: 18, color: Colors.grey.shade600),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     "Secure Payment",
  //                     style: Get.textTheme.titleLarge
  //                         ?.copyWith(fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 16),
  //
  //               /// TAB
  //               TabBar(
  //                 indicatorColor: Get.theme.colorScheme.primary,
  //                 labelColor: Get.theme.colorScheme.primary,
  //                 unselectedLabelColor: Colors.grey,
  //                 tabs: const [
  //                   Tab(text: "Pay Now"),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 12),
  //
  //               /// BODY
  //               Obx(
  //                     () => authController.isLoading.value
  //                     ? const Expanded(
  //                   child: Center(child: CircularProgressIndicator()),
  //                 )
  //                     : Expanded(
  //                   child: TabBarView(
  //                     children: [
  //                       _upiPaymentTab(),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //   );
  // }
  //
  //
  // Widget _upiPaymentTab() {
  //   final RxInt selectedAmount = 100.obs;
  //   final TextEditingController amountController =
  //   TextEditingController(text: '100');
  //
  //   final List<int> suggestedAmounts = [100, 500, 1000, 2000, 5000];
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         /// AMOUNT CARD
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             gradient: LinearGradient(
  //               colors: [
  //                 Get.theme.colorScheme.primary,
  //                 Get.theme.colorScheme.primary.withOpacity(0.8),
  //               ],
  //             ),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Amount to Pay",
  //                 style: TextStyle(
  //                   color: Colors.white.withOpacity(0.8),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Obx(
  //                     () => Text(
  //                   "₹ ${selectedAmount.value}",
  //                   style: const TextStyle(
  //                     fontSize: 32,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         const SizedBox(height: 24),
  //
  //         /// QUICK SELECT
  //         Text(
  //           "Quick Select",
  //           style: Get.textTheme.titleMedium
  //               ?.copyWith(fontWeight: FontWeight.w600),
  //         ),
  //
  //         const SizedBox(height: 12),
  //
  //         Wrap(
  //           spacing: 12,
  //           runSpacing: 12,
  //           children: suggestedAmounts.map((amount) {
  //             return Obx(
  //                   () => ChoiceChip(
  //                 label: Text("₹$amount"),
  //                 selected: selectedAmount.value == amount,
  //                 onSelected: (_) {
  //                   selectedAmount.value = amount;
  //                   amountController.text = amount.toString();
  //                 },
  //                 selectedColor: Get.theme.colorScheme.primary,
  //                 backgroundColor:
  //                 Get.theme.colorScheme.primary.withOpacity(0.1),
  //                 labelStyle: TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                   color: selectedAmount.value == amount
  //                       ? Colors.white
  //                       : Get.theme.colorScheme.primary,
  //                 ),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(14),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //
  //         const Spacer(),
  //
  //         /// PAY BUTTON
  //         Obx(
  //               () => SizedBox(
  //             width: double.infinity,
  //             height: 56,
  //             child: ElevatedButton.icon(
  //               icon: const Icon(Icons.arrow_forward),
  //               onPressed: () async {
  //                 final payAmount = selectedAmount.value;
  //
  //                 await phonePeAuthController.startTransaction(payAmount);
  //
  //                 if (phonePeAuthController.paymentsuccess.value
  //                     .toString() ==
  //                     "1") {
  //                   await phonePeAuthController.uploadPaymentData(
  //                     amount: payAmount.toString(),
  //                     orderId:
  //                     phonePeAuthController.orderid.value.toString(),
  //                     transactionId:
  //                     phonePeAuthController.orderid.value.toString(),
  //                     status: phonePeAuthController.paymentstatus.value
  //                         .toString(),
  //                     aadhar:
  //                     authController.usermodel.value?.aadhar ?? "",
  //                     screenshotPhoto: '',
  //                     mop: 'pg',
  //                   );
  //
  //                   await paymentsController.fetchPayments(
  //                     memberId:
  //                     authController.usermodel.value?.id ?? "",
  //                   );
  //
  //                   Get.back();
  //                 }
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 elevation: 6,
  //                 backgroundColor: Get.theme.colorScheme.primary,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(18),
  //                 ),
  //               ),
  //               label: Text(
  //                 "Pay ₹${selectedAmount.value}",
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


}

// import 'package:aiphc/controllers/auth/login.dart';
// import 'package:aiphc/controllers/globalcontroller.dart';
// import 'package:aiphc/controllers/paymentcontroller.dart';
// import 'package:aiphc/controllers/phonepaycontroller.dart';
// import 'package:aiphc/model/paymentmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../widgets/appbar.dart';
//
// class Payments extends StatefulWidget {
//   const Payments({super.key});
//
//   @override
//   State<Payments> createState() => _PaymentsState();
// }
//
// class _PaymentsState extends State<Payments> {
//
//   final PaymentsController paymentsController =
//   Get.find<PaymentsController>();
//
//
//   final Globalcontroller globalcontroller = Get.find();
//
//   final AuthController authController = Get.find();
//   final PhonePeController phonePeAuthController = Get.find();
//   @override
//   void initState() {
//     super.initState();
//     paymentsController.fetchPayments(memberId: authController.usermodel.value?.id??""); // fetch all payments
//     // paymentsController.fetchPayments(memberId: "1597");
//   }
//
//   // ✅ Month Number ➜ Month Name formatter
//   String formatMonthYear(String month, String year) {
//     final int m = int.tryParse(month) ?? 1;
//
//     const months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//
//     final String monthName =
//     (m >= 1 && m <= 12) ? months[m - 1] : month;
//
//     return "$monthName / $year";
//   }
//
//
//   void _showPaymentPopup() {
//     Get.bottomSheet(
//       SafeArea(
//         child: DefaultTabController(
//           length: 1,
//           child: Container(
//             height: Get.height * 0.75,
//             decoration: BoxDecoration(
//               color: Get.theme.scaffoldBackgroundColor,
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(26),
//               ),
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//
//                 /// DRAG HANDLE
//                 Container(
//                   width: 60,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Get.isDarkMode
//                         ? Colors.grey.shade700
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 Text(
//                   "Complete Payment",
//                   style: Get.textTheme.titleLarge
//                       ?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 /// TABS
//                 Column(
//                   children: [
//                     TabBar(
//                       indicatorColor: Get.theme.primaryColor,
//                       labelColor: Get.theme.primaryColor,
//                       unselectedLabelColor: Colors.grey,
//                       tabs: const [
//                         Tab(text: "Pay Now"),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 /// TAB VIEWS
//                 Obx(()=> authController.isLoading.value==true?Center(child: Container(child: CircularProgressIndicator())): Expanded(
//                   child: TabBarView(
//                     children: [
//                       _upiPaymentTab(),
//                     ],
//                   ),
//                 ),),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//     );
//   }
//   Widget _upiPaymentTab() {
//     final RxInt selectedAmount = 100.obs;
//     final TextEditingController amountController =
//     TextEditingController(text: '100');
//
//     /// 🔥 Added 100 here
//     final List<int> suggestedAmounts = [100, 500, 1000, 2000, 5000];
//
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Amount title
//             Text(
//               "Enter Amount",
//               style: Get.textTheme.titleMedium,
//             ),
//             const SizedBox(height: 12),
//
//             /// Amount input (read-only)
//             TextField(
//               controller: amountController,
//               enabled: false,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 prefixText: "₹ ",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             /// Suggested amounts
//             Text(
//               "Quick Select",
//               style: Get.textTheme.titleSmall,
//             ),
//             const SizedBox(height: 10),
//
//             Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: suggestedAmounts.map((amount) {
//                 return Obx(
//                       () => ChoiceChip(
//                     label: Text("₹$amount"),
//                     selected: selectedAmount.value == amount,
//                     onSelected: (_) {
//                       selectedAmount.value = amount;
//                       amountController.text = amount.toString();
//                     },
//                     selectedColor: Get.theme.colorScheme.primary,
//                     labelStyle: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: selectedAmount.value == amount
//                           ? Colors.white
//                           : Get.theme.colorScheme.onSurface,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//
//             const Spacer(),
//
//             /// Proceed button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: Obx(
//                     () => ElevatedButton(
//                   onPressed: () async{
//                     final payAmount = selectedAmount.value;
//                     print("Proceed to pay ₹$payAmount");
//                     // startUpiPayment(payAmount);
//                     await phonePeAuthController.startTransaction(payAmount);
//
//                     if(phonePeAuthController.paymentsuccess.value.toString()=="1"){
//                         await phonePeAuthController.uploadPaymentData( amount: payAmount.toString(), orderId: phonePeAuthController.orderid.toString(), transactionId: phonePeAuthController.orderid.value.toString(), status: phonePeAuthController.paymentstatus.value.toString(),aadhar: authController.usermodel.value?.aadhar.toString()??"",screenshotPhoto: '', mop: 'pg');
//                     await paymentsController.fetchPayments(memberId: authController.usermodel.value?.id.toString()??"");
//                         Get.back();
//                     }
//
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: Text(
//                     "Proceed to Pay ₹${selectedAmount.value} ",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomeAppBar(title: "Payments"),
//
//       body: Column(
//         children: [
//           MaterialButton(
//               onPressed: (){
//                 _showPaymentPopup();
//               },color: Colors.green,
//               child: Text("Add Payment",style: TextStyle(color: Colors.white),)),
//           Expanded(
//             child: Obx(() {
//               if (paymentsController.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               if (paymentsController.payments.isEmpty) {
//                 return const Center(child: Text("No payments found"));
//               }
//
//               return ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: paymentsController.payments.length,
//                 itemBuilder: (context, index) {
//                   final Payment payment =
//                   paymentsController.payments[index];
//
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     margin: const EdgeInsets.only(bottom: 12),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(14),
//                       onTap: () => showPaymentDetails(payment),
//                       child: Padding(
//                         padding: const EdgeInsets.all(14),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor:
//                               payment.status == "SUCCESS"
//                                   ? Colors.green
//                                   : Colors.red,
//                               child: const Icon(
//                                 Icons.payments,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(width: 14),
//
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "₹ ${payment.amount}",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium
//                                         ?.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Order: ${payment.orderId}",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall,
//                                   ),
//                                   Text(
//                                     formatMonthYear(
//                                         payment.month, payment.year),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall,
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             Text(
//                               payment.status,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: payment.status == "SUCCESS"
//                                     ? Colors.green
//                                     : Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🔥 PAYMENT DETAILS BOTTOM SHEET
//   void showPaymentDetails(Payment payment) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Get.theme.cardColor,
//           borderRadius: const BorderRadius.vertical(
//             top: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 50,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             Text(
//               "Payment Details",
//               style: Get.textTheme.titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//
//             _row("Amount", "₹ ${payment.amount}"),
//             _row("Status", payment.status),
//             _row("Order ID", payment.orderId),
//             // _row("Transaction ID", payment.transactionId),
//             _row(
//               "Month / Year",
//               formatMonthYear(payment.month, payment.year),
//             ),
//             _row("Payment Date", payment.date),
//             // _row("Created At", payment.dateCreated),
//
//             const SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () => Get.back(),
//                 child: const Text("CLOSE"),
//               ),
//             )
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }
//
//   // 🔹 Reusable row widget
//   Widget _row(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               title,
//               style: Get.textTheme.bodyMedium
//                   ?.copyWith(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }
