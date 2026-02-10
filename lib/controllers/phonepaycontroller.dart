import 'dart:convert';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePeController extends GetxController {

  var flowid="Test".obs;
  var authToken="".obs;
  var orderToken="".obs;
  var orderid="".obs;
  var expiresAt="".obs;
  var appSchema = "com.wintechings.aiphc".obs;
  var paymentsuccess = "0".obs;
  var paymentstatus = "".obs;


  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await initSdk();
  }


  Future<void> initSdk()async{
    await PhonePePaymentSdk.init(ServerConstants.payenvmode.toString(), ServerConstants.PHONEPE_MERCHANT_ID.toString(), flowid.value.toString(),
        true).then((isInitialized)=> {
      print("initialized ::::: $isInitialized")
    }).catchError((onError){
      print("onError : $onError");
      return <dynamic>{};
    });
  }


  Future<void> getauthtoken() async {
    final response = await Dio().post(
      "${ServerConstants.PHONEPE_AUTH_URL}",
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: {
        'client_id': "${ServerConstants.PHONEPE_CLIENT_ID}",
        'client_version': "1",
        'client_secret': "${ServerConstants.PHONEPE_CLIENT_SECRET}",
        'grant_type': 'client_credentials',
      },
    );

    authToken.value = response.data['access_token'].toString();
    orderid.value = response.data['orderId'].toString();
    expiresAt.value = response.data['expires_at'].toString();

    print("getauthtoken:::: :${authToken.toString()}");
    print("getauthtoken:::: :${authToken.toString()}");
  }


  Future<void> createOrder(int amount) async {
    final int amountInPaise = amount * 100;
    final response = await Dio().post(
      "${ServerConstants.PHONEPE_AUTH_URLorder}",
      options: Options(
        headers: {
          'Authorization': 'O-Bearer ${authToken.value.toString()}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        "merchantOrderId": "TX_${DateTime.now().millisecondsSinceEpoch}",
        "amount": amountInPaise,
        "paymentFlow": {
          "type": "PG_CHECKOUT",
        },
      },
    );

    orderToken.value = response.data['token'].toString();
    orderid.value = response.data['orderId'].toString();
    print("fjbsksdbjkbfjkds :${response.data.toString()}");
    print("fjbsksdbjkbfjkds :${orderToken.toString()}");
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

  void showPaymentSuccessPopup() {
    Get.defaultDialog(
      title: "Payment Successful 🎉",
      middleText: "Your payment has been completed successfully.",
      radius: 12,
      titleStyle: const TextStyle(color: Colors.green),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          Get.back();
          // 👉 navigate if needed
          // Get.offAllNamed('/home');
        },
        child: const Text("OK"),
      ),
    );
  }




  Future<void> startTransaction(int amount)async {

    await getauthtoken();
    await createOrder(amount);

    await PhonePePaymentSdk.startTransaction(jsonEncode({
      "orderId": "${orderid.value}",
      "merchantId": "${ServerConstants.PHONEPE_MERCHANT_ID}",
      "token": "${orderToken.value}",
      "paymentMode": {"type": "PAY_PAGE"}
    }
    ), appSchema.value)
        .then((response) {
      print("fjkdbjkfbdjkf :${response.toString()}");
      if (response != null) {
        String status = response['status'].toString();
        paymentstatus.value=status.toString();
        String error = response['error'].toString();
        if (status == 'SUCCESS') {
          print("success");
          paymentsuccess.value="1";
          showPaymentSuccessPopup();

        } else {
          print("failed");
          showPaymentFailedPopup();
        }
      } else {
        print("Flow incomplete");
        showPaymentFailedPopup();
      }
    });
  }


  Future<void> uploadPaymentData({
    required String aadhar,
    // required String memberId,
    required String amount,
    required String orderId,
    required String transactionId,
    required String status,
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
