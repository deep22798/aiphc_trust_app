import 'dart:convert';

import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AutopayController extends GetxController {
  final Dio _dio = Dio();
  AuthController authController =Get.find<AuthController>();
  PhonePeController phonePeController =Get.find<PhonePeController>();

  var isLoading = false.obs;
  var accessToken = ''.obs;
  var errorMessage = ''.obs;
  var mechantsubsid = ''.obs;
  var ordertoken = ''.obs;
  var orderid = ''.obs;
  var appSchema = "com.wintechwings.aipvst".obs;
  var paymentsuccess = "0".obs;
  var paymentstatus = "".obs;
  var autopaysts="".obs;



  Future<void> getAccessToken() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _dio.post(
        '${ServerConstants.PHONEPE_AUTH_URL}',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'client_id': '${ServerConstants.PHONEPE_CLIENT_ID}',
          'client_version': '1',
          'client_secret': '${ServerConstants.PHONEPE_CLIENT_SECRET}',
          'grant_type': 'client_credentials',
        },
      );

      // ✅ Debug print
      print('PhonePe Token Response: ${response.data}');

      if (response.statusCode == 200) {
        accessToken.value = response.data['access_token'];

        print('PhonePe Token Response: ${accessToken.value}');
      } else {
        errorMessage.value = 'Failed to get token';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('PhonePe Token Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOrdderSubscription() async {

    SharedPreferences prefs= await SharedPreferences.getInstance();
    var subsid=await prefs.getString("lastmerchsubsid");



    final response = await _dio.get(
      "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/order/${subsid.toString()}/status",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "O-Bearer ${accessToken.toString()}",
        },
      ),
    );

    final state = response.data['state'];

    print("Subscription State: ${response.data.toString()}");
    print("Subscription State: $state");

    if (state == "COMPLETED") {
      await _dio.post(
        ServerConstants.updatesubscriptionid,
        data: {
          "member_id": authController.usermodel.value?.id.toString()??"",
          "subscription_id": subsid.toString(),
          "autopay_status": "ACTIVE",
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      SharedPreferences prefs= await SharedPreferences.getInstance();
      var u= await prefs.getString("username");
      var p= await prefs.getString("password");

      await authController.userLogintemp(aadhar: u.toString(), password: p.toString());
    }
  }

  Future<void> checkSubscriptionstatus() async {

    print("d,jfjbjsdkfksb :${authController.usermodel.value?.subscriptionId.toString()}");
    SharedPreferences prefs= await SharedPreferences.getInstance();
    var subsid=await prefs.getString("lastmerchsubsid");
if(authController.usermodel.value?.subscriptionId.toString()!=null||authController.usermodel.value?.subscriptionId.toString()!="null"||authController.usermodel.value?.subscriptionId.toString()!="0"){
    final response = await _dio.get(
      "https://api-preprod.phonepe.com/apis/pg-sandbox/subscriptions/v2/${authController.usermodel.value?.subscriptionId.toString()}/status?details=true",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "O-Bearer ${accessToken.toString()}",
        },
      ),
    );

    final state = response.data['state'];
    if(state.toString()=="ACTIVE"){
      autopaysts.value=state.toString();
      print("cjbdvjbsd :${autopaysts.value}");
    }


    print("Subscription State: ${response.data.toString()}");
    print("Subscription State: $state");}else{autopaysts.value="INACTIVE";}
  }

  Future<void> setupSubscription(int amount) async {
    final String merchantOrderId =
          "MO${DateTime.now().millisecondsSinceEpoch}";

      final String merchantSubscriptionId =
          "MS${DateTime.now().millisecondsSinceEpoch}";

    const String url =

        "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/sdk/order";

    final body = {
      "merchantOrderId": merchantOrderId,
      "amount": amount*100,
      "metaInfo": {
        "udf1": "flutter_app",
        "udf2": "subscription",
        "udf3": "user_flow",
      },
      "paymentFlow": {
        "type": "SUBSCRIPTION_CHECKOUT_SETUP",
        "message": "Approve UPI Autopay Mandate",
        // "merchantUrls": {
        //   "redirectUrl": "https://trust.aiphc.in/phonepe/return",
        //   "cancelRedirectUrl": "https://trust.aiphc.in/phonepe/cancel",
        // },
        "subscriptionDetails": {
          "subscriptionType": "RECURRING",
          "merchantSubscriptionId": merchantSubscriptionId.toString(),
          "authWorkflowType": "TRANSACTION",
          "amountType": "FIXED",
          "maxAmount": 100000*100,
          "frequency": "ON_DEMAND",
          "productType": "UPI_MANDATE",
          "expireAt": DateTime.now()
              .add(const Duration(days: 365))
              .millisecondsSinceEpoch,
        }
      },
      "expireAfter": 3000,
    };


    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
          },
        ),
      );

      // 🔥 Print full response
      debugPrint("✅ Checkout SDK Order Response:");
      debugPrint(response.data.toString());

      if(response.data['token']!=null){
        ordertoken.value=response.data['token'];
        orderid.value=response.data['orderId'];
        print("sdfjskjfsdf :${ordertoken.value}");
        print("sdfjskjfsdf :${orderid.value}");
        startTransaction(amount,merchantSubscriptionId.toString(),merchantOrderId);
      }

      // Common useful fields
      final data = response.data;
      debugPrint("🧾 merchantOrderId: ${data['merchantOrderId']}");
      debugPrint("🔗 redirectUrl: ${data['redirectUrl']}");
      debugPrint("📌 merchantSubscriptionId: $merchantSubscriptionId");

      // Open approval page (sandbox)
      if (data['redirectUrl'] != null) {
        await launchUrl(
          Uri.parse(data['redirectUrl']),
          mode: LaunchMode.externalApplication,
        );
      }

    } on DioException catch (e) {
      debugPrint("❌ Dio Error (Checkout SDK)");
      debugPrint("StatusCode: ${e.response?.statusCode}");
      debugPrint("ErrorBody: ${e.response?.data}");
    } catch (e) {
      debugPrint("❌ Unknown Error: $e");
    }
  }


  Future<void> startTransaction(int amount,String subscriptionid,merchantOrderId)async {

    await PhonePePaymentSdk.startTransaction(jsonEncode({
      "orderId": "${orderid.value}",
      "merchantId": "${ServerConstants.PHONEPE_MERCHANT_ID}",
      "token": "${ordertoken.value}",
      "paymentMode": {"type": "PAY_PAGE"}
    }
    ), appSchema.value)
        .then((response) async {
      print("fjkdbjkfbdjkf :${response.toString()}");
      if (response != null) {
        String status = response['status'].toString();
        paymentstatus.value=status.toString();
        String error = response['error'].toString();
        if (status == 'SUCCESS') {
          print("success");
          paymentsuccess.value="1";
          mechantsubsid.value=subscriptionid.toString();
              SharedPreferences prefs= await SharedPreferences.getInstance();
              prefs.setString("lastmerchsubsid", "${subscriptionid.toString()}");
          await phonePeController.uploadPaymentData(
              aadhar: authController.usermodel.value?.aadhar.toString()??"",
              amount: amount.toString(),
              orderId: orderid.value,
              transactionId: merchantOrderId,
              status: status, mop: 'autopay');
          // showPaymentSuccessPopup();

        } else {
          print("failed");
          // showPaymentFailedPopup();
        }
      } else {
        print("Flow incomplete");
        // showPaymentFailedPopup();
      }
    });
  }



  Future<void> redeemSubscriptionnotify() async {
    final String merchantOrderId =
        "MO${DateTime.now().millisecondsSinceEpoch}";

    final body = {
      "merchantOrderId": merchantOrderId,
      "amount": 1000,
      "expireAt": DateTime.now()
          .add(const Duration(minutes: 10))
          .millisecondsSinceEpoch,
      "paymentFlow": {
        "type": "SUBSCRIPTION_REDEMPTION",
        "merchantSubscriptionId": authController.usermodel.value?.subscriptionId.toString(),
        "redemptionRetryStrategy": "CUSTOM",
        "autoDebit": false
      }
    };

    try {
      final res = await Dio().post(
        "https://api-preprod.phonepe.com/apis/pg-sandbox/subscriptions/v2/notify",
        data: body,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "O-Bearer ${accessToken.value}",
        }),
      );

      print("✅ Response: ${res.data}");

    } on DioException catch (e) {
      print("❌ Dio Error: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("❌ Error: $e");
    }
    checkOrderStatus(merchantOrderId);
  }

  Future<void> checkOrderStatus(String merchantOrderId) async {
    final String url =
        "https://api-preprod.phonepe.com/apis/pg-sandbox/subscriptions/v2/order/$merchantOrderId/status?details=true";

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
          },
        ),
      );

      // 🔥 Print full response
      debugPrint("📦 Order Status API Response:");
      debugPrint(response.data.toString());

      // Optional: pretty fields
      final data = response.data;
      debugPrint("🧾 merchantOrderId: ${data['merchantOrderId']}");
      debugPrint("📌 subscriptionId: ${data['paymentFlow']['merchantSubscriptionId']}");
      debugPrint("📊 state: ${data['state']}");
      await redeemOrder(merchantOrderId);

    } on DioException catch (e) {
      debugPrint("❌ Dio Error");
      debugPrint("StatusCode: ${e.response?.statusCode}");
      debugPrint("ErrorBody: ${e.response?.data}");
    } catch (e) {
      debugPrint("❌ Unknown Error: $e");
    }
  }

  Future<void> redeemOrder(String merchantOrderId) async {
    const String url =
        "https://api-preprod.phonepe.com/apis/pg-sandbox/subscriptions/v2/redeem";

    final body = {
      "merchantOrderId": merchantOrderId,
    };

    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "O-Bearer ${accessToken.value}",
          },
        ),
      );

      // 🔥 Print full response
      debugPrint("✅ Redeem API Response: ${response.data.toString()}");
      debugPrint(response.data.toString());
      // Optional fields (if present)
      if (response.data is Map) {
        debugPrint("🧾 merchantOrderId: ${response.data['merchantOrderId']}");
        debugPrint("📊 state: ${response.data['state']}");
      }

    } on DioException catch (e) {
      debugPrint("❌ Dio Error (Redeem)");
      debugPrint("StatusCode: ${e.response?.statusCode}");
      debugPrint("ErrorBody: ${e.response?.data}");
    } catch (e) {
      debugPrint("❌ Unknown Error: $e");
    }
  }












// final Dio dio = Dio();
  // RxBool loading = false.obs;
  // RxString error = "".obs;
  // RxString autopayStatus = "".obs;
  //
  //
  //
  // Future<void> enableAutopay(int userId) async {
  //   loading.value = true;
  //   error.value = "";
  //
  //   try {
  //     final res = await dio.post(
  //       "${ServerConstants.baseUrl}api/subscription/setup",
  //       data: {"user_id": userId},
  //       options: Options(validateStatus: (_) => true),
  //     );
  //
  //     print("AUTOPAY RESPONSE => ${res.data}");
  //
  //     if (res.statusCode != 200 || res.data == null) {
  //       error.value = "Server error";
  //       return;
  //     }
  //
  //     final redirectUrl = res.data['redirectUrl'];
  //
  //     if (redirectUrl == null || redirectUrl.toString().isEmpty) {
  //       error.value = "Redirect URL not received from PhonePe";
  //       return;
  //     }
  //
  //     final uri = Uri.parse(redirectUrl);
  //
  //     if (!await canLaunchUrl(uri)) {
  //       error.value = "No app found to open AutoPay link";
  //       return;
  //     }
  //
  //     await launchUrl(
  //       uri,
  //       mode: LaunchMode.platformDefault,
  //     );
  //
  //   } catch (e) {
  //     error.value = e.toString();
  //     print("AUTOPAY ERROR => $e");
  //   } finally {
  //     loading.value = false;
  //   }
  // }
  //
  // Future<void> loadStatus(int userId) async {
  //   final res = await dio.get(
  //     "${ServerConstants.baseUrl}api/autopay-status/$userId",
  //   );
  //   autopayStatus.value = res.data['autopay'] ?? 'INACTIVE';
  // }
  //
  // Future<List> history(int userId) async {
  //   final res = await dio.get(
  //     "${ServerConstants.baseUrl}api/payment-history/$userId",
  //   );
  //   return res.data ?? [];
  // }


//
// Future<void> setupSubscription(String id) async {
//   String merchantOrderId =
//       "MO${DateTime.now().millisecondsSinceEpoch}";
//
//   String merchantSubscriptionId =
//       "MS${DateTime.now().millisecondsSinceEpoch}";
//
//
//   final body = {
//     "merchantOrderId": "${merchantOrderId.toString()}",
//     "amount": 200,
//     "expireAt": 1709058548000,
//     "metaInfo": {
//       "udf1": "${id}",
//       "udf2": "some meta info of max length 256",
//     },
//     "paymentFlow": {
//       "type": "SUBSCRIPTION_SETUP",
//       "merchantSubscriptionId": "${merchantSubscriptionId.toString()}",
//       "authWorkflowType": "TRANSACTION",
//       "amountType": "VARIABLE",
//       "maxAmount": 2000,
//       "frequency": "ON_DEMAND",
//       "expireAt": 1737278524000,
//       "paymentMode": {
//         "type": "UPI_COLLECT",
//         "details": {
//           "type": "VPA",
//           "vpa": "success@ybl" // use success@ybl / failure@ybl / pending@ybl
//         }
//       }
//
//     }
//   };
//
//   try {
//     final response = await _dio.post(
//       "${ServerConstants.PHONEPE_AUTH_URLsubscription}",
//       data: body,
//       options: Options(
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "O-Bearer ${accessToken.value}",
//         },
//       ),
//     );
//
//     print("Response: ${response.data}");
//   } on DioException catch (e) {
//     print("Dio Error: ${e.response?.data}");
//   } catch (e) {
//     print("Error: $e");
//   }
// }


// Future<void> setupSubscription(String userId) async {
//   final String merchantOrderId =
//       "MO${DateTime.now().millisecondsSinceEpoch}";
//
//   final String merchantSubscriptionId =
//       "MS${DateTime.now().millisecondsSinceEpoch}";
//
//   final Map<String, dynamic> body = {
//     "merchantOrderId": merchantOrderId,
//     "amount": 12000,
//     "paymentFlow": {
//       "type": "SUBSCRIPTION_CHECKOUT_SETUP",
//       "message": "Payment message used for collect requests",
//       // "merchantUrls": {
//       //   "redirectUrl": "https://www.google.com",
//       //   "cancelRedirectUrl": "https://www.google.com",
//       // },
//       "merchantUrls": {
//         "redirectUrl": "https://trust.aiphc.in/phonepe/return",
//         "cancelRedirectUrl": "https://trust.aiphc.in/phonepe/cancel"
//       },
//
//       "subscriptionDetails": {
//         "subscriptionType": "RECURRING",
//         "merchantSubscriptionId": merchantSubscriptionId,
//         "authWorkflowType": "TRANSACTION",
//         "amountType": "FIXED",
//         "maxAmount": 47900,
//         "frequency": "ON_DEMAND",
//         "productType": "UPI_MANDATE",
//         "expireAt": DateTime.now()
//             .add(const Duration(days: 365))
//             .millisecondsSinceEpoch,
//       }
//     },
//     "expireAfter": 3000,
//     "metaInfo": {
//       "udf1": userId,
//       "udf2": "flutter-app",
//       "udf3": "subscription-checkout",
//       "udf4": "v1",
//       "udf5": "extra-info",
//       "udf6": "extra-info",
//       "udf7": "extra-info",
//       "udf8": "extra-info",
//       "udf10": "extra-info",
//       "udf11": "short-info",
//       "udf12": "short-info",
//       "udf13": "short-info",
//       "udf14": "short-info",
//       "udf15": "short-info",
//     }
//   };
//
//   try {
//     final response = await _dio.post(
//       ServerConstants.PHONEPE_AUTH_URLsubscription,
//       data: body,
//       options: Options(
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "O-Bearer ${accessToken.value}",
//         },
//       ),
//     );
//
//     debugPrint("🧾 OrderId: $merchantOrderId");
//     debugPrint("📌 SubscriptionId: $merchantSubscriptionId");
//     debugPrint("✅ Response: ${response.data}");
//
//     mechantsubsid.value=merchantSubscriptionId.toString();
//     SharedPreferences prefs= await SharedPreferences.getInstance();
//     prefs.setString("lastmerchsubsid", "${merchantSubscriptionId.toString()}");
//     final redirectUrl = response.data['redirectUrl'];
//
//     await launchUrl(
//       Uri.parse(redirectUrl),
//       mode: LaunchMode.externalApplication,
//     );
//
//   } on DioException catch (e) {
//     debugPrint("❌ Dio Error: ${e.response?.data}");
//   } catch (e) {
//     debugPrint("❌ Error: $e");
//   }
// }

}
