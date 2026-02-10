
import 'package:aiphc/model/bannermodel.dart';
import 'package:aiphc/model/driverlistmodel.dart';
import 'package:aiphc/model/membermodel.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembersController extends GetxController{

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await fetchMembers();
    await fetchDrivers();
  }

  var bannerloading=false.obs;

  final RxList<MemberModel> members = <MemberModel>[].obs;

  var currentCarouselIndex = 0.obs;
  Future<void> fetchMembers() async {
    try {
      bannerloading.value = true;

      final response = await Dio().get(
        ServerConstants.members,
      );

      final data = response.data;
      print("MEMBERS RESPONSE ::: $data");

      if (data['status'] == true) {

        // ✅ Parse & save banner list
        final List list = data['data'] ?? [];
        members.value =
            list.map((e) => MemberModel.fromJson(e)).toList();

        print("RESPONSE ::: ${members.value.first.name}");
        // Get.snackbar(
        //   'Success',
        //   data['message'] ?? 'Banners fetched',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        // Get.snackbar(
        //   'Error',
        //   data['message'] ?? 'Failed to fetch banners',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    } on DioException catch (e) {
      // Get.snackbar(
      //   'Error',
      //   e.response?.data['message'] ?? 'Server not responding',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      bannerloading.value = false;
    }
  }


  var drivers = <Member>[].obs;
  var selectedMember = Rxn<Member>();
  var isLoading = false.obs;

  // var driverss = <Member>[].obs;

  var selectedMembers = <Member>[].obs;

  // var isLoading = false.obs;

  // ✅ Comma separated IDs
  String get selectedMemberIds =>
      selectedMembers.map((e) => e.id).join(',');

  void toggleMember(Member member) {
    if (selectedMembers.any((m) => m.id == member.id)) {
      selectedMembers.removeWhere((m) => m.id == member.id);
    } else {
      selectedMembers.add(member);
    }
  }


  Future<void> fetchDrivers() async {
    try {
      isLoading.value = true;

      final response = await Dio().get(
        "${ServerConstants.baseUrl}/api/getMember?category=3",
      );


      if (response.statusCode == 200 && response.data['status'] == true) {
        final List list = response.data['data'];
        drivers.value = list.map((e) => Member.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Member API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectMember(Member member) {
    selectedMember.value = member;
  }



  Future<void> submitMemberDrivers({
    required String aadhar,
  }) async {
    try {
      isLoading.value = true;

      final response = await Dio().post(
        "${ServerConstants.baseUrl}/api/addMemberDriver",
        data: {
          "aadhar": aadhar,
          "driver_ids": selectedMemberIds,
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        Get.snackbar(
          "Success",
          "Drivers assigned successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          response.data['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "API Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }



}