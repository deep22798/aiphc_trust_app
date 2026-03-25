import 'dart:convert';
import 'dart:io';

import 'package:aiphc/model/knyadaanmodel.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

class DashboardController extends GetxController {
  RxInt currentPage = 0.obs;
 var isLoading=false.obs;


  final RxBool loading = false.obs;
  final RxList<KanyadaanMember> members = <KanyadaanMember>[].obs;
  final RxList<KanyadaanMember> memberss = <KanyadaanMember>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchKanyadaanMembers();
  }


  Future<void> fetchKanyadaanMemberss({String? memberId}) async {
    try {
      loading.value = true;

      final dio = Dio();

      final res = await dio.get(
        ServerConstants.getKanyadaanMembers,
        queryParameters: memberId != null
            ? {"member_id": memberId}
            : null,
      );

      if (res.data["status"] == true) {
        memberss.value = (res.data["data"] as List)
            .map((e) => KanyadaanMember.fromJson(e))
            .toList();
      } else {
        memberss.clear();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data");
    } finally {
      loading.value = false;
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

     await fetchKanyadaanMembers();
      debugPrint("✅ Kanyadaan Update Response: ${response.data}");
    } on DioException catch (e) {
      debugPrint("❌ Dio Error: ${e.response?.data}");
    } catch (e) {
      debugPrint("❌ Error: $e");
    }
  }


  Future<void> fetchKanyadaanMembers() async {
    try {
      loading.value = true;
      final dio = Dio();
      final res = await dio.get(ServerConstants.getKanyadaanMembers);

      if (res.data['status'] == true) {
        members.value = List<KanyadaanMember>.from(
          res.data['data'].map(
                (e) => KanyadaanMember.fromJson(e),
          ),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load kanyadaan members :${e.toString()}");
    } finally {
      loading.value = false;
    }
  }



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

  Future<void> updateKanyadaanStatuss({
    required String memberId,
    required int kanyadaan,
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
  //
  // Future<void> addKanyadaan(
  //     String member_id,
  //     String daughter_name,
  //     String daughter_mobile,
  //     String bank_name,
  //     String account_no,
  //     String account_ifsccode,
  //     context
  //     ) async {
  //   try {
  //
  //     final response = await Dio().post(
  //         ServerConstants.adddkanyaadaan,
  //       data: jsonEncode({
  //         "member_id": member_id,
  //         "daughter_name": daughter_name,
  //         "daughter_mobile": daughter_mobile,
  //         "bank_name": bank_name,
  //         "account_no": account_no,
  //         "account_ifsccode": account_ifsccode
  //       }),
  //       options: Options(
  //         contentType: Headers.jsonContentType, // application/json
  //         responseType: ResponseType.json,
  //       ),
  //     );
  //
  //     print("✅ Donation API Response:");
  //     debugPrint(response.data.toString());
  //
  //     if (response.data['status'] == true) {
  //       await updateKanyadaanStatus(memberId: member_id, kanyadaan: "1");
  //       Get.back();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Registration done ❤️"),
  //       ),
  //
  //
  //     );
  //
  //       // Get.snackbar("Success", "Donation added successfully");
  //     } else {
  //       // Get.snackbar("Error", response.data['messages']?['error'] ?? "Failed");
  //     }
  //
  //   } on DioException catch (e) {
  //     debugPrint("❌ Status Code: ${e.response?.statusCode}");
  //     debugPrint("❌ Response: ${e.response?.data}");
  //     // Get.snackbar("Error", "Server error");
  //   } catch (e) {
  //     debugPrint("❌ Error: $e");
  //     // Get.snackbar("Error", "Something went wrong");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> addKanyadaan(
      String member_id,
      String daughter_name,
      String daughter_mobile,
      String bank_name,
      String account_no,
      String account_ifsccode,
      File? imageFile,
      context,
      ) async {
    try {

      FormData formData = FormData.fromMap({
        "member_id": member_id,
        "daughter_name": daughter_name,
        "daughter_mobile": daughter_mobile,
        "bank_name": bank_name,
        "account_no": account_no,
        "account_ifsccode": account_ifsccode,

        // 🔥 Image
        if (imageFile != null)
          "marriage_card": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await Dio().post(
        ServerConstants.adddkanyaadaan,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      print("✅ Response: ${response.data}");

      if (response.data['status'] == true) {
        await updateKanyadaanStatus(memberId: member_id, kanyadaan: "1");

        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration done ❤️")),
        );
      }

    } catch (e) {
      print("❌ Error: $e");
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
