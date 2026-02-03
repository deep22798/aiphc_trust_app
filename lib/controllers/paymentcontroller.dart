import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:aiphc/utils/serverconstants.dart';

class PaymentController extends GetxController {

  /// 🔐 SANDBOX KEYS
  static const String _saltKey =
      "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  static const String _saltIndex = "1";

  @override
  void onInit() {
    super.onInit();
    _initPhonePe();
  }

  /// 1️⃣ INIT PHONEPE SDK (SANDBOX)
  Future<void> _initPhonePe() async {
    final flowId = "FLOW_${DateTime.now().millisecondsSinceEpoch}";

    await PhonePePaymentSdk.init(
      "SANDBOX", // ✅ MUST BE EXACT
      ServerConstants.PHONEPE_MERCHANT_ID,
      flowId,
      true,
    );
  }

  /// 2️⃣ CREATE BASE64 PAYLOAD
  String _createBase64Payload() {
    final txnId = DateTime.now().millisecondsSinceEpoch.toString();

    final payload = {
      "merchantId": ServerConstants.PHONEPE_MERCHANT_ID,
      "merchantTransactionId": txnId, // ✅ ONLY NUMERIC
      "merchantUserId": "USER123",
      "amount": 1000, // ₹10 (in paise)
      "callbackUrl": "https://webhook.site/test",
      "paymentInstrument": {
        "type": "PAY_PAGE"
      }
    };

    return base64Encode(utf8.encode(jsonEncode(payload)));
  }

  /// 3️⃣ GENERATE CHECKSUM (SANDBOX)
  String _generateChecksum(String base64Payload) {
    /// ❌ DO NOT ADD /sandbox HERE
    final data = "$base64Payload/pg/v1/pay$_saltKey";
    final hash = sha256.convert(utf8.encode(data)).toString();
    return "$hash###$_saltIndex";
  }

  /// 4️⃣ FINAL REQUEST
  String _createFinalRequest() {
    final base64Payload = _createBase64Payload();
    final checksum = _generateChecksum(base64Payload);

    return jsonEncode({
      "request": base64Payload,
      "checksum": checksum,
    });
  }

  /// 5️⃣ START PAYMENT
  Future<void> payNow() async {
    try {
      final response = await PhonePePaymentSdk.startTransaction(
        _createFinalRequest(),
        "com.wintechings.aiphc", // packageName / appId
      );

      debugPrint("PHONEPE RESPONSE => $response");
    } catch (e) {
      debugPrint("PHONEPE ERROR => $e");
    }
  }
}

class ButtonPage extends StatelessWidget {
  ButtonPage({super.key});

  final PaymentController controller =
  Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            controller.payNow();

          },
          child: const Text("Pay with PhonePe"),
        ),
      ),
    );
  }
}

