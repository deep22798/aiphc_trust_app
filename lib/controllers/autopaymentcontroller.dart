// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../utils/serverconstants.dart';
//
// class Autopaymentcontroller extends GetxController {
//
//   final Dio _dio = Dio();
//
//   var accessToken = "".obs;
//   var merchantOrderId = ''.obs;
//   var merchantSubId = ''.obs;
//
//   var orderstatus = "".obs;
//
//   /// 🔹 STEP 1: Generate Token
//   Future<void> generateToken() async {
//     try {
//       final response = await _dio.post(
//         ServerConstants.autopaytoken,
//         data: {
//           "client_id": ServerConstants.autopayclientid,
//           "client_version": "1",
//           "client_secret": ServerConstants.autopaysecretid,
//           "grant_type": "client_credentials",
//         },
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//         ),
//       );
//
//       accessToken.value = response.data["access_token"] ?? "";
//       print("TOKEN: ${accessToken.value}");
//
//     } catch (e) {
//       print("Token Error: $e");
//     }
//   }
//
//   /// 🔥 STEP 2: Setup Subscription
//   Future<void> setupSubscription(int amount) async {
//
//     if (accessToken.value.isEmpty) {
//       await generateToken();
//     }
//
//     try {
//
//       merchantOrderId.value = "MO${DateTime.now().millisecondsSinceEpoch}";
//       merchantSubId.value = "MS${DateTime.now().millisecondsSinceEpoch}";
//
//       final response = await _dio.post(
//         "${ServerConstants.autopaysetupsubscription}",
//         data: {
//           "merchantOrderId": merchantOrderId.value,
//           "amount": amount,
//           "paymentFlow": {
//             "type": "SUBSCRIPTION_CHECKOUT_SETUP",
//             "merchantUrls": {
//               // 🔥 IMPORTANT: use HTTPS (NOT myapp:// directly)
//               "redirectUrl": "myapp://payment-success"
//             },
//             "subscriptionDetails": {
//               "subscriptionType": "RECURRING",
//               "merchantSubscriptionId": merchantSubId.value,
//               "authWorkflowType": "TRANSACTION",
//               "amountType": "FIXED",
//               "maxAmount": amount,
//               "frequency": "ON_DEMAND",
//               "productType": "UPI_MANDATE",
//               "expireAt": DateTime.now().millisecondsSinceEpoch + 86400000,
//             }
//           },
//           "expireAfter": 3000,
//           "metaInfo": {
//             "udf1": "test1",
//             "udf2": "test2",
//           }
//         },
//         options: Options(
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "O-Bearer ${accessToken.value}",
//           },
//         ),
//       );
//
//       print("SETUP RESPONSE: ${response.data}");
//
//       String redirectUrl = response.data["redirectUrl"];
//
//       print("OPENING: $redirectUrl");
//
//       await openPaymentPage(redirectUrl);
//
//     } catch (e) {
//       print("Setup Error: $e");
//     }
//   }
//
//   /// 🔥 STEP 3: Open Payment Page
//   Future<void> openPaymentPage(String url) async {
//     final uri = Uri.parse(url);
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   /// 🔥 STEP 4: Poll Order Status
//   Future<void> pollOrderUntilComplete() async {
//
//     for (int i = 0; i < 10; i++) {
//
//       await Future.delayed(const Duration(seconds: 3));
//
//       final url =
//           "${ServerConstants.autopayorderstatus}${merchantOrderId.value}/status?details=true";
//
//       final response = await _dio.get(
//         url,
//         options: Options(
//           headers: {
//             "Authorization": "O-Bearer ${accessToken.value}",
//           },
//         ),
//       );
//
//       String state = response.data["state"];
//       orderstatus.value = response.data.toString();
//
//       print("ORDER STATE: $state");
//
//       if (state == "COMPLETED") {
//         print("✅ Order Completed");
//         return;
//       }
//     }
//   }
//
//   /// 🔥 STEP 5: Check Subscription
//   Future<void> checkSubscriptionStatus() async {
//
//     try {
//
//       final url =
//           "${ServerConstants.autopaysubscriptionstatus}${merchantSubId.value}/status?details=true}";
//
//       final response = await _dio.get(
//         url,
//         options: Options(
//           headers: {
//             "Authorization": "O-Bearer ${accessToken.value}",
//           },
//         ),
//       );
//
//       print("SUBSCRIPTION: ${response.data}");
//
//
//
//     } catch (e) {
//       print("Subscription Error: $e");
//     }
//   }
//
//
//
//
//
//
//
// }
//
//


import 'dart:convert';

import 'package:aiphc/utils/serverconstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class Autopaymentcontroller extends GetxController {

  final Dio _dio = Dio();

  var accessToken = "".obs;
  var isLoading = false.obs;
  var appSchema = "com.wintechwings.aipvst".obs;

  var merchantOrderId = ''.obs;
  var merchantSubId = ''.obs;


  var OrderId = "".obs;
  var accessOrderToken = "".obs;


  var subscriptionstatus = "".obs;


  var paymentsuccess = "0".obs;
  var paymentstatus = "".obs;


  var transactionid = "".obs;
  var orderId = "".obs;


  /// 🔹 STEP 1: Generate Access Token
  ///
  ///
  ///
  ///
  ///

  var flowid="PRODUCTION2026".obs;

  Future<void> initSdk()async{
    await PhonePePaymentSdk.init(ServerConstants.autopaypayenvmainmode.toString(), ServerConstants.autopaymerchantid.toString(), flowid.value.toString(),
        true).then((isInitialized)=> {
      print("initialized ::::: $isInitialized")
    }).catchError((onError){
      print("onError : $onError");
      return <dynamic>{};
    });
  }




  Future<void> generateToken() async {
    try {
await initSdk();
      final data = {
        "client_id": ServerConstants.autopayclientid,
        "client_version": "1",
        "client_secret": ServerConstants.autopaysecretid,
        "grant_type": "client_credentials",
      };

      final response = await _dio.post(
        ServerConstants.autopaytoken,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("FULL RESPONSE: ${response.data}");

      accessToken.value = response.data["access_token"] ?? "";

      print("Access Token: ${accessToken.value}");

    } catch (e) {
      print("Token Error: $e");
    }
  }


  /// 🔹 STEP 2: Create Order Token (Autopay)
  ///
  ///
  Future<void> createOrder(int amount) async {

    if (accessToken.value.isEmpty) {
      print("Access token missing, generating...");
      await generateToken();
    }

    isLoading.value = true;

    try {

       merchantOrderId.value = await "MO${DateTime.now().millisecondsSinceEpoch}";
       merchantSubId.value = await "MS${DateTime.now().millisecondsSinceEpoch}";


      final response = await _dio.post(
        "${ServerConstants.autopayordertoken}",
        data: {
          "merchantOrderId": merchantOrderId.value,
          "amount": amount,
          "paymentFlow": {
            "type": "SUBSCRIPTION_CHECKOUT_SETUP",
            "message": "Subscription Payment",
            "subscriptionDetails": {
              "subscriptionType": "RECURRING",
              "merchantSubscriptionId": merchantSubId.value,
              "authWorkflowType": "TRANSACTION",
              "amountType": "FIXED",
              "maxAmount": amount,
              "frequency": "ON_DEMAND",
              "productType": "UPI_MANDATE",
              "expireAt": DateTime.now().millisecondsSinceEpoch + 86400000, // +1 day
            }
          },
          "expireAfter": 3000,
          "metaInfo": {
            "udf1": "test1",
            "udf2": "test2",
          }
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
          },
        ),
      );

      print("Order Response: ${response.data.toString()}");
       accessOrderToken.value = response.data["token"] ?? "";
       OrderId.value = response.data["orderId"] ?? "";

// Debug
      print("Stored Token: ${accessOrderToken.value}");
      print("Stored OrderId: ${OrderId.value}");

    } catch (e) {
      print("Order Error: $e");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> startTransaction(int amount,String memberId,aadhar)async {
    await initSdk();
    await generateToken();
    await createOrder(amount*100);

    await PhonePePaymentSdk.startTransaction(jsonEncode({
      "orderId": "${OrderId.value}",
      "merchantId": "${ServerConstants.autopaymerchantid}",
      "token": "${accessOrderToken.value}",
      "paymentMode": {"type": "PAY_PAGE"}
    }

    ), appSchema.value)
        .then((response) async{
      print("fjkdbjkfbdjkf :${response.toString()}");
      if (response != null) {
        String status = response['status'].toString();
        paymentstatus.value=status.toString();
        String error = response['error'].toString();
        if (status == 'SUCCESS') {
          paymentsuccess.value = "1";
          await pollOrderUntilComplete();   // ✅ wait properly
          await checkSubscriptionStatus(memberId,aadhar,amount);  // ✅ now safe
        } else {
          print("failed");
          // showPaymentFailedPopup();
        }
      } else {
        print("Flow incomplete");
        showPaymentFailedPopup();
      }
    });
  }




  Future<void> checkOrderStatus() async {

    if (accessToken.value.isEmpty) {
      print("Access token missing...");
      return;
    }

    if (OrderId.value.isEmpty) {
      print("OrderId missing...");
      return;
    }


    try {
      final url = "${ServerConstants.autopayorderstatus}${merchantOrderId.value}/status";

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
          },
        ),
      );

      print("STATUS RESPONSE: ${response.data}");

      // 🔥 Important fields
      var state = response.data["state"];
      var paymentDetails = response.data["paymentDetails"];

      print("Order State: $state");
      print("Order State: ${paymentDetails.toString()}");

    } catch (e) {
      print("Status Error: $e");
    }

  }



var orderstatus="".obs;
  Future<void> pollOrderUntilComplete() async {

    String state = "";

    for (int i = 0; i < 5; i++) { // retry 10 times

      await Future.delayed(Duration(seconds: 3));

      final url =
          "${ServerConstants.autopayorderstatus}${merchantOrderId.value}/status?details=true";

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
          },
        ),
      );
      var data = response.data;

      String state = data["state"];

      if (data["paymentDetails"] != null &&
          data["paymentDetails"].isNotEmpty) {
        transactionid.value = data["paymentDetails"][0]["transactionId"] ?? "";
        orderId.value = data["orderId"] ?? "";
      }
      state = response.data["state"];
      print("Polling Order State FULL : ${response.data.toString()}");
      orderstatus.value=response.data.toString();

      print("Polling Order State: $state");

      if (state == "COMPLETED") {
        print("✅ Order Completed");
        return;
      }
    }

    print("❌ Order not completed after polling");
  }



  Future<void> checkSubscriptionStatus(String memberId,aadhar,amount) async {

    if (accessToken.value.isEmpty) {
      print("Access token missing...");
      return;
    }

    if (merchantSubId.value.isEmpty) {
      print("merchantSubscriptionId missing...");
      return;
    }


    try {

      final url =
          "${ServerConstants.autopaysubscriptionstatus}${merchantSubId.value}/status?details=true";

      print("FINAL URL: $url");

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
            "merchantSubscriptionId": "${ServerConstants.autopaymerchantid}",
          },
        ),
      );


      print("SUBSCRIPTION RESPONSE: ${response.data}");

      // 🔥 Important fields
      var state = response.data["state"];
      var subscriptionId = response.data["subscriptionId"];

      print("Subscription State: $state");
      // print("SubscriptionId: $subscriptionId");

      if(state.toString()=="ACTIVE"){
        await updateSubscription(memberId: memberId,merchantsubscriptionid: subscriptionId.toString(), subscriptionId: merchantSubId.value, autopayStatus: state.toString());
        await uploadPaymentData(aadhar: aadhar.toString(), amount: amount.toString(), orderId: orderId.value.toString(), transactionId: transactionid.value.toString(), status: state.toString(), mop: 'autopay_subscription');

      }


    } catch (e) {
      print("Subscription Error: $e");
    }
  }






  Future<void> AutopayStatus(String subscriptionidd) async {

    if (accessToken.value.isEmpty) {
      print("Access token missing...");
      await generateToken();
    }

    if (subscriptionidd.isEmpty) {
      print("merchantSubscriptionId missing...");
      return;
    }


    try {

      final url =
          "${ServerConstants.autopaysubscriptionstatus}${subscriptionidd}/status?details=true";
      print("FINAL URL: $url");

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
            "merchantSubscriptionId": "${ServerConstants.autopaymerchantid}",
          },
        ),
      );


      print("SUBSCRIPTION RESPONSE: ${response.data}");

      // 🔥 Important fields
      var state = response.data["state"];
      var subscriptionId = response.data["subscriptionId"];

      print("Subscription State: $state");
      print("SubscriptionId: $subscriptionId");

      if(state.toString()=="ACTIVE"){
        subscriptionstatus.value=state;
        // updateSubscription(memberId: memberId,merchantsubscriptionid: subscriptionId.toString(), subscriptionId: merchantSubId.value, autopayStatus: state.toString());
      }

    } catch (e) {
      print("Subscription Error: $e");
    }
  }





  void showPaymentFailedPopup({String message = "Payment failed. Please try again."}) {
    Get.defaultDialog(
      title: "Payment Failed ❌",
      middleText: message,
      radius: 12,
      titleStyle: const TextStyle(color: Colors.red),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          Get.back();
        },
        child: const Text("Retry"),
      ),
    );
  }





  Future<void> updateSubscription({
    required String memberId,
    required String merchantsubscriptionid,
    required String subscriptionId,
    required String autopayStatus,
  }) async {
    try {
      isLoading.value = true;

      final response = await _dio.post(
        "${ServerConstants.updatesubscriptionid}",
        data: {
          "member_id": memberId,
          "merchantsubscriptionid": merchantsubscriptionid,
          "subscription_id": subscriptionId,
          "autopay_status": autopayStatus,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        Get.snackbar("Success", "Subscription Updated");
      } else {
        Get.snackbar("Error", "Update Failed");
      }
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> uploadPaymentData({
    required String aadhar,
    // required String memberId,
    required String amount,
    required String orderId,
    required String transactionId,
    required String status,
    required String mop,
    String screenshotPhoto = "",
  }) async {
    try {
      final dio = Dio();

      final DateTime now = DateTime.now();

      final String year = now.year.toString();
      final String month = now.month.toString();
      final String date =
          "${now.day.toString().padLeft(2, '0')}-"
          "${now.month.toString().padLeft(2, '0')}-"
          "${now.year}";

      final response = await dio.post(
        ServerConstants.create_payment_api,
        data: {
          "aadhar": aadhar,
          // "member_id": memberId,
          "month": month,
          "year": year,
          "date": date,
          "mop": mop,
          "type": "AUTOPAY",
          "amount": amount,
          "screenshot_photo": screenshotPhoto,
          "order_id": orderId,
          "transaction_id": transactionId,
          "status": status,
        },


        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      debugPrint("RESPONSE: ${response.data}");


      if (response.statusCode == 200 && response.data['status'] == true) {
        debugPrint("✅ Payment uploaded successfully");
      } else {
        debugPrint("❌ Upload failed: ${response.data}");
      }
    } catch (e) {
      debugPrint("🚫 API Error: $e");
    }
  }



}