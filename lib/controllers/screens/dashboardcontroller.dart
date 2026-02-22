import 'dart:convert';

import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt currentPage = 0.obs;
 var isLoading=false.obs;

  Future<void> addDonationSimple(
      String name,
      String mobile,
      String message,
      String orderid,
      String txnid,
      String status,
      String amount,
      ) async {
    try {

      final response = await Dio().post(
        ServerConstants.adddonations,
        data: jsonEncode({
          "order_id": orderid,
          "name": name,
          "mobile_no": mobile,
          "message": message,
          "amount": amount,
          "status": status,
          "transaction_id": txnid,
        }),
        options: Options(
          contentType: Headers.jsonContentType, // application/json
          responseType: ResponseType.json,
        ),
      );

      print("✅ Donation API Response:");
      debugPrint(response.data.toString());

      if (response.data['status'] == true) {
        // Get.snackbar("Success", "Donation added successfully");
      } else {
        // Get.snackbar("Error", response.data['messages']?['error'] ?? "Failed");
      }

    } on DioException catch (e) {
      debugPrint("❌ Status Code: ${e.response?.statusCode}");
      debugPrint("❌ Response: ${e.response?.data}");
      // Get.snackbar("Error", "Server error");
    } catch (e) {
      debugPrint("❌ Error: $e");
      // Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateKanyadaanStatus({
    required String memberId,
    required String kanyadaan,
  }) async {
    try {
      final response = await Dio().post(
        ServerConstants.updatekanyadaansts, // your API URL
        data: {
          "member_id": memberId,
          "kanyadaan": kanyadaan,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      debugPrint("✅ Kanyadaan Update Response: ${response.data}");
    } on DioException catch (e) {
      debugPrint("❌ Dio Error: ${e.response?.data}");
    } catch (e) {
      debugPrint("❌ Error: $e");
    }
  }

  Future<void> addKanyadaan(
      String member_id,
      String daughter_name,
      String daughter_mobile,
      String bank_name,
      String account_no,
      String account_ifsccode,
      context
      ) async {
    try {

      final response = await Dio().post(
        ServerConstants.adddkanyaadaan,
        data: jsonEncode({
          "member_id": member_id,
          "daughter_name": daughter_name,
          "daughter_mobile": daughter_mobile,
          "bank_name": bank_name,
          "account_no": account_no,
          "account_ifsccode": account_ifsccode
        }),
        options: Options(
          contentType: Headers.jsonContentType, // application/json
          responseType: ResponseType.json,
        ),
      );

      print("✅ Donation API Response:");
      debugPrint(response.data.toString());

      if (response.data['status'] == true) {
        await updateKanyadaanStatus(memberId: member_id, kanyadaan: "1");
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration done ❤️"),
        ),


      );

        // Get.snackbar("Success", "Donation added successfully");
      } else {
        // Get.snackbar("Error", response.data['messages']?['error'] ?? "Failed");
      }

    } on DioException catch (e) {
      debugPrint("❌ Status Code: ${e.response?.statusCode}");
      debugPrint("❌ Response: ${e.response?.data}");
      // Get.snackbar("Error", "Server error");
    } catch (e) {
      debugPrint("❌ Error: $e");
      // Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  final gridItems = const [
    {"icon": "people", "label": "सभी सदस्यों की सूची\nAll Member list"},
    {"icon": "gallery", "label": "गैलरी\nGallery"},
    {"icon": "rules", "label": "प्रक्रिया / निर्देश\nRules"},
  ];

  final carouselItems = const [
    "Education Support Programs",
    "Health & Medical Camps",
    "Community Welfare Initiatives",
  ];

  final listItems = const [
    {"icon": "vhelp", "label": "वित्तीय सहायता\nVittiya Sahayata"},
    {"icon": "help", "label": "पेंशन सहायता\nPension Help"},
    // {"icon": "donate", "label": "दान\nDonation"},
  ];

  final listItems2 = const [
    {"icon": "vhelp", "label": "वित्तीय सहायता\nVittiya Sahayata"},
    {"icon": "help", "label": "पेंशन सहायता\nPension Help"},
    // {"icon": "donate", "label": "दान\nDonation"},
    // {"icon": "donate", "label": "कन्यादान \nKanyadaan"},
  ];

  void updatePage(int index) {
    currentPage.value = index;
  }
  var currentIndex = 0.obs;


  void changeTab(int index) {
    currentIndex.value = index;
  }

}
