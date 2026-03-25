import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/paymentcontroller.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
import 'package:aiphc/controllers/screens/dashboardcontroller.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verifidkanyadaan extends StatefulWidget {
  final String memberId;

  const Verifidkanyadaan({
    super.key,
    required this.memberId,
  });

  @override
  State<Verifidkanyadaan> createState() => _VerifidkanyadaanState();
}

class _VerifidkanyadaanState extends State<Verifidkanyadaan> {
  final DashboardController controller = Get.find();
  final PaymentsController paymentsController = Get.find();
  final AuthController authcontroller = Get.find();
  bool isload=false;

  final phonePeAuthController = Get.find<PhonePeController>();
  @override
  void initState() {
    super.initState();
    // ✅ fetch only ONE member
    print("dsfjkndjkgjfd :${widget.memberId.toString()}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchKanyadaanMemberss(memberId: widget.memberId);
        paymentsController.fetchPayments(memberId:  widget.memberId.toString());
      });
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomeAppBar(title: "Kanyadaan (कन्यादान)"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showKanyadaanDialog(context);

        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.memberss.isEmpty) {
          return const Center(child: Text("No data found"));
        }

        final m = controller.memberss.first;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= HEADER CARD =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: m.kanyadaan == "2"
                        ? [Colors.green.shade600, Colors.green.shade400]
                        : [Colors.red.shade600, Colors.red.shade400],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      backgroundImage: m.userPhoto.isNotEmpty
                          ? NetworkImage(
                        ServerAssets.baseUrl +
                            "uploads/member/" +
                            m.userPhoto,
                      )
                          : null,
                      child: m.userPhoto.isEmpty
                          ? const Icon(Icons.person, size: 42)
                          : null,
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.mobile,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              m.kanyadaan == "2"
                                  ? "✔ Verified"
                                  : "⏳ Pending Verification",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= MEMBER DETAILS =================
              _section(
                "Member Details",
                [
                  _infoCard(Icons.location_on, "State", m.state),
                  _infoCard(Icons.location_city, "District", m.district),
                  // _infoCard(Icons.map, "Block", m.block),
                ],
              ),

              _section(
                "Daughter Details",
                [
                  _infoCard(Icons.person, "Name", m.daughterName),
                  _infoCard(Icons.phone, "Mobile", m.daughterMobile),
                ],
              ),

              _section(
                "Bank Details",
                [
                  _infoCard(Icons.account_balance, "Bank", m.bankName),
                  _infoCard(Icons.credit_card, "Account", m.accountNo),
                  _infoCard(Icons.code, "IFSC", m.ifsc),
                ],
              ),

              const SizedBox(height: 24),

              /// ================= PAYMENTS =================
              Text(
                "Kanyadaan Payments",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Obx(() {
                if (paymentsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final payments = paymentsController.payments
                    .where((p) =>
                p.mop.toLowerCase().trim() == "kanyadaan")
                    .toList();

                if (payments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("No kanyadaan payments found"),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final p = payments[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹ ${p.amount}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: p.status.toLowerCase() ==
                                      "success"
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  p.status.toUpperCase(),
                                  style: TextStyle(
                                    color: p.status.toLowerCase() ==
                                        "success"
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          _payRow("Month", "${p.month} ${p.year}"),
                          _payRow("Transaction", p.transactionId),
                          _payRow("Order ID", p.orderId),
                          _payRow("Date", p.dateCreated),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }
  /// ================= INFO ROW =================
  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// ================= PAYMENT ROW =================
  Widget _payRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(value),
          ),
        ],
      ),
    );
  }


  void showKanyadaanDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController mobileController = TextEditingController();
    TextEditingController banknameController = TextEditingController();
    TextEditingController accnoController = TextEditingController();
    TextEditingController accifscController = TextEditingController();
    final List<int> suggestedAmounts = [501, 1001, 5001];

    final RxInt selectedAmount = 501.obs;
    final TextEditingController amountController =
    TextEditingController(text: '501');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

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

                    SizedBox(height: 25),

                    /// Donate Button
                    isload==true?CircularProgressIndicator():SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async{
                          setState(() {
                            isload=true;
                          });

                          final payAmount = selectedAmount.value;
                          print("Proceed to pay ₹$payAmount");
                          // startUpiPayment(payAmount);
                          if (_formKey.currentState!.validate()) {
                            await phonePeAuthController.startTransaction(payAmount);


                            if(phonePeAuthController.paymentsuccess.value.toString()=="1"){
                              await phonePeAuthController.uploadPaymentData( amount: payAmount.toString(), orderId: phonePeAuthController.orderid.toString(), transactionId: phonePeAuthController.orderid.value.toString(), status: phonePeAuthController.paymentstatus.value.toString(),aadhar: authcontroller.usermodel.value?.aadhar.toString()??"",screenshotPhoto: '', mop: 'kanyadaan', type: 'KANYADAAN');
                              await paymentsController.fetchPayments(memberId: authcontroller.usermodel.value?.id.toString()??"");
                              // await controller.addKanyadaan(
                              //     authcontroller.usermodel.value?.id.toString()??"",
                              //     nameController.text,
                              //     mobileController.text,
                              //     banknameController.text,
                              //     accnoController.text,
                              //     accifscController.text,context);
                              SharedPreferences prefs= await SharedPreferences.getInstance();
                              var u= await prefs.getString("username");
                              var p= await prefs.getString("password");
                              await authcontroller.userLogintemp(aadhar: u.toString(), password: p.toString());
                              Get.back();
                            }

                          }
                          //
                          // await controller.addDonationSimple();
                          setState(() {
                            isload=false;
                          });
                          // Navigator.pop(context);

                        },
                        child: Text(
                          "Add now (अभी जोड़ें)",
                          style: TextStyle(
                            fontSize: 16,color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}