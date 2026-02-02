
import 'package:aiphc/model/bannermodel.dart';
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


}