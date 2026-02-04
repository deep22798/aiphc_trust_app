import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class MerchantApp extends StatefulWidget {
  const MerchantApp({super.key});

  @override
  State<MerchantApp> createState() => _MerchantAppState();
}

class _MerchantAppState extends State<MerchantApp> {

  /// 🔐 PRODUCTION CONFIG
  static const String environment = "PRODUCTION";
  static const String merchantId = "M22WT1JEYXRO5";
  static const String saltKey = "YOUR_SALT_KEY_HERE";
  static const String saltIndex = "1";
  static const String appSchema = "com.wintechings.aiphc";

  String flowId = "FLOW_${DateTime.now().millisecondsSinceEpoch}";
  String result = "—";

  /// ================= INIT SDK =================
  Future<void> initSdk() async {
    final res = await PhonePePaymentSdk.init(
      environment,
      merchantId,
      flowId,
      true,
    );
    setState(() {
      result = "SDK Init: $res";
    });
  }

  /// ================= TXN ID =================
  String generateTxnId() {
    return "TXN${DateTime.now().millisecondsSinceEpoch}";
  }

  /// ================= CREATE PAYLOAD =================
  Map<String, dynamic> createPayload() {
    return {
      "merchantId": merchantId,
      "merchantTransactionId": generateTxnId(),
      "merchantUserId": "USER001",
      "amount": 10000, // ₹100.00 (paise)
      "redirectUrl": "https://webhook.site/redirect-url",
      "redirectMode": "POST",
      "callbackUrl": "https://webhook.site/callback-url",
      "paymentInstrument": {
        "type": "PAY_PAGE"
      }
    };
  }

  /// ================= CHECKSUM =================
  String generateChecksum(String base64Body) {
    final data = base64Body + "/pg/v1/pay" + saltKey;
    final hash = sha256.convert(utf8.encode(data)).toString();
    return "$hash###$saltIndex";
  }

  /// ================= START PAYMENT =================
  Future<void> startPayment() async {
    try {
      final payload = createPayload();
      final jsonPayload = jsonEncode(payload);
      final base64Body = base64Encode(utf8.encode(jsonPayload));
      final checksum = generateChecksum(base64Body);

      final request = jsonEncode({
        "request": base64Body,
        "checksum": checksum,
      });

      final response =
      await PhonePePaymentSdk.startTransaction(request, appSchema);

      setState(() {
        if (response != null) {
          if (response["status"] == "SUCCESS") {
            result = "✅ PAYMENT SUCCESS";
          } else {
            result =
            "❌ FAILED\nStatus: ${response["status"]}\nError: ${response["error"]}";
          }
        } else {
          result = "❌ Transaction Cancelled";
        }
      });
    } catch (e) {
      setState(() {
        result = "❌ Exception: $e";
      });
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("PhonePe PRODUCTION")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: initSdk,
                child: const Text("INIT SDK"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: startPayment,
                child: const Text("START PAYMENT"),
              ),
              const SizedBox(height: 24),
              Text(result),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:aiphc/utils/serverconstants.dart';
//
// class PaymentController extends GetxController {
//
//   /// 🔐 SANDBOX KEYS
//   static const String _saltKey =
//       "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
//   static const String _saltIndex = "1";
//
//   @override
//   void onInit() {
//     super.onInit();
//     initPhonePe();
//   }
//
//   var result=''.obs;
//   /// 1️⃣ INIT PHONEPE SDK (SANDBOX)
//   Future<void> initPhonePe() async {
//     PhonePePaymentSdk.init("SANDBOX", "M22WT1JEYXRO5", "M34djnh", true)
//         .then((isInitialized) => {
//       // setState(() {
//         result.value = 'PhonePe SDK Initialized - $isInitialized'
//       // })
//     }
//     ).catchError((error) {
//       // handleError(error);
//       print("fjksdbfewbfjk ${error.toString()}");
//       return <dynamic > {};
//     });
//     // final flowId = "FLOW_${DateTime.now().millisecondsSinceEpoch}";
//     //
//     // var res = await PhonePePaymentSdk.init(
//     //   "PRODUCTION",
//     //   // "SANDBOX",
//     //   ServerConstants.PHONEPE_MERCHANT_ID,
//     //   flowId,
//     //   true,
//     // );
//     //
//     // print("fdjksbdjkvdkvjb : ${res.toString()}");
//   }
//
//
//
//
//
//   /// 2️⃣ CREATE BASE64 PAYLOAD
//   String _createBase64Payload() {
//     final txnId = DateTime.now().millisecondsSinceEpoch.toString();
//
//     final payload = {
//       "merchantId": ServerConstants.PHONEPE_MERCHANT_ID,
//       "merchantTransactionId": txnId, // ✅ ONLY NUMERIC
//       "merchantUserId": "USER123",
//       "amount": 1000, // ₹10 (in paise)
//       "callbackUrl": "https://webhook.site/test",
//       "paymentInstrument": {
//         "type": "PAY_PAGE"
//       }
//     };
//
//     return base64Encode(utf8.encode(jsonEncode(payload)));
//   }
//
//   /// 3️⃣ GENERATE CHECKSUM (SANDBOX)
//   String _generateChecksum(String base64Payload) {
//     /// ❌ DO NOT ADD /sandbox HERE
//     final data = "$base64Payload/pg/v1/pay$_saltKey";
//     final hash = sha256.convert(utf8.encode(data)).toString();
//     return "$hash###$_saltIndex";
//   }
//
//   /// 4️⃣ FINAL REQUEST
//   String _createFinalRequest() {
//     final base64Payload = _createBase64Payload();
//     final checksum = _generateChecksum(base64Payload);
//
//     return jsonEncode({
//       "request": base64Payload,
//       "checksum": checksum,
//     });
//   }
//
//   /// 5️⃣ START PAYMENT
//   Future<void> payNow() async {
//     try {
//       final response = await PhonePePaymentSdk.startTransaction(
//         _createFinalRequest(),
//         "com.wintechings.aiphc", // packageName / appId
//       );
//
//       debugPrint("PHONEPE RESPONSE => $response");
//     } catch (e) {
//       debugPrint("PHONEPE ERROR => $e");
//     }
//   }
// }
//
// class ButtonPage extends StatelessWidget {
//   ButtonPage({super.key});
//
//   final PaymentController controller =
//   Get.put(PaymentController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             controller.initPhonePe();
//             // controller.payNow();
//
//           },
//           child: const Text("Pay with PhonePe"),
//         ),
//       ),
//     );
//   }
// }
//
