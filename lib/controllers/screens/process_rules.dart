
import 'package:aiphc/model/bannermodel.dart';
import 'package:aiphc/model/membermodel.dart';
import 'package:aiphc/model/processrules.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:aiphc/view/screens/process/process.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcessController extends GetxController{

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await fetchProceess();
  }

  var bannerloading=false.obs;

  final RxList<ProcessRulesmodel> processrules = <ProcessRulesmodel>[].obs;

  var currentCarouselIndex = 0.obs;
  Future<void> fetchProceess() async {
    try {
      bannerloading.value = true;

      final response = await Dio().get(
        ServerConstants.rules,
      );

      final data = response.data;
      print("PROCESS RESPONSE ::: $data\n${ServerConstants.rules}");
      print("PROCESS RESPONSE :::\n${ServerConstants.rules}");

      if (data['status'] == true) {

        // ✅ Parse & save banner list
        final List list = data['data'] ?? [];
        processrules.value =
            list.map((e) => ProcessRulesmodel.fromJson(e)).toList();

        print("RESPONSE ::: ${processrules.value.first.description}");
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