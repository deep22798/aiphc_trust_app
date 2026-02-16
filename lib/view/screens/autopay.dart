  import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/autopaycontroller.dart';
  import 'package:aiphc/view/widgets/appbar.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';

  class Autopay extends StatefulWidget {
    const Autopay({super.key});

    @override
    State<Autopay> createState() => _AutopayState();
  }

  class _AutopayState extends State<Autopay> {
    final c = Get.put(AutopayController());
    final a = Get.put(AuthController());
    // final int userId = 101;


    @override
    void initState() {
      super.initState();
      // c.loadStatus(int.parse(a.usermodel.value?.id.toString()??"0")); // ✅ correct place
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Autopay")),
        body: Column(
          children: [
            Obx(()=> Text(c.autopaysts.value)),
            MaterialButton(onPressed: (){c.getAccessToken();},child: Text("Generate toekn"),),
            MaterialButton(onPressed: (){c.setupSubscription(100); setState(() {
            });},child: Text("Setup Autopay"),),
            MaterialButton(onPressed: (){c.verifyOrdderSubscription();setState(() {
            });},child: Text("check order Autopay"),),
            MaterialButton(onPressed: (){c.checkSubscriptionstatus();},child: Text("check Autopay status"),),
            MaterialButton(onPressed: (){c.redeemSubscriptionnotify();},child: Text("check redeemSubscription status"),),

            // Obx(() => Text(
            //   "Status: ${c.autopayStatus.value}",
            //   style: const TextStyle(fontSize: 18),
            // )),
            //
            //
            // Obx(() => c.loading.value
            //     ? const CircularProgressIndicator()
            //     : ElevatedButton(
            //   onPressed: () => c.enableAutopay(int.parse(a.usermodel.value?.id.toString()??"0")),
            //   child: const Text("Enable AutoPay"),
            // )),
            //
            // Obx(() => c.error.value.isNotEmpty
            //     ? Text(c.error.value,
            //     style: const TextStyle(color: Colors.red))
            //     : const SizedBox()),
            //
            // Expanded(
            //   child: FutureBuilder(
            //     future: c.history(int.parse(a.usermodel.value?.id.toString()??"0")),
            //     builder: (_, snap) {
            //       if (!snap.hasData) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //
            //       final list = snap.data as List;
            //       if (list.isEmpty) {
            //         return const Center(child: Text("No payments yet"));
            //       }
            //
            //       return ListView.builder(
            //         itemCount: list.length,
            //         itemBuilder: (_, i) {
            //           final p = list[i];
            //           return ListTile(
            //             title: Text("₹${p['amount']??""}"),
            //             subtitle: Text("${p['month']??""}/${p['year']??""}"),
            //             trailing: Text(p['status']??""),
            //           );
            //         },
            //       );
            //
            //     },
            //   ),
            // )
          ],
        ),
      );
    }
  }



