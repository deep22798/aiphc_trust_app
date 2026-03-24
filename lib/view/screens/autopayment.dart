import 'dart:async';
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

  late AppLinks _appLinks;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initDeepLink();
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
      await controller.checkSubscriptionStatus();
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

            ElevatedButton(
              onPressed: () async {
                await controller.generateToken();
              },
              child: const Text("Generate Token"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await controller.setupSubscription(100);
              },
              child: const Text("Setup Autopay"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await controller.pollOrderUntilComplete();
                await controller.checkSubscriptionStatus();
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