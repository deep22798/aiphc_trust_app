import 'dart:async';
import 'package:aiphc/controllers/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

import '../../controllers/autopaymentcontroller.dart';

class AutoPayment extends StatefulWidget {
  const AutoPayment({super.key});

  @override
  State<AutoPayment> createState() => _AutoPaymentState();
}

class _AutoPaymentState extends State<AutoPayment> {

  final controller = Get.put(Autopaymentcontroller());

  final authcontroller = Get.find<AuthController>();

  late AppLinks _appLinks;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initDeepLink();
    controller.AutopayStatus(authcontroller.enablerole.value == 2?authcontroller.usermodel.value?.subscriptionId.toString()??"":"");
  }


  /// 🔥 HANDLE DEEP LINK
  void initDeepLink() async {

    _appLinks = AppLinks();

    /// App closed case
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      handleDeepLink(uri);
    }

    /// App running case
    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    });
  }

  void handleDeepLink(Uri uri) async {
    print("DEEPLINK: $uri");

    if (uri.host == "payment-success") {

      await controller.pollOrderUntilComplete();
      // await controller.checkSubscriptionStatus(authcontroller.enablerole.value == 2?authcontroller.usermodel.value?.id??"":"");
    }
  }

  @override
  void dispose() {
    _sub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autopay")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Obx(()=>Text("${controller.subscriptionstatus}")),


            Obx(()=>Text("${authcontroller.enablerole.value == 2?authcontroller.usermodel.value?.id??"":""}")),
            Obx(()=>Text("${controller.merchantSubId.value}")),
            Obx(()=>Text("${controller.merchantOrderId.value}")),

            ElevatedButton(
              onPressed: () async {
                await controller.generateToken();
              },
              child: const Text("Generate Token"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await controller.startTransaction(100,authcontroller.enablerole.value == 2?authcontroller.usermodel.value?.id??"":"",authcontroller.enablerole.value == 2?authcontroller.usermodel.value?.aadhar??"":"");
              },
              child: const Text("Setup Autopay"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await controller.pollOrderUntilComplete();
                // await controller.checkSubscriptionStatus(authcontroller.enablerole.value == 2?authcontroller.usermodel.value?.id??"":"");
              },
              child: const Text("Check Status"),
            ),

            const SizedBox(height: 20),

            Obx(() => Text(controller.orderstatus.value)),
          ],
        ),
      ),
    );
  }
}